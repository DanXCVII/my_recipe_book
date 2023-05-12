import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:googleapis/analytics/v3.dart';
import 'package:googleapis/drive/v3.dart' as GD;
import 'package:http/http.dart' as http;

import '../local_storage/hive.dart';
import '../local_storage/io_operations.dart' as IO;
import '../local_storage/local_paths.dart';
import '../models/recipe.dart';
import '../models/tuple.dart';
import '../util/helper.dart';

enum Status {
  DELETED_LOCAL,
  DELETED_ONLINE,
  UPLOADED,
  IMPORTED_LOCAL,
  FINISHED,
}

class DriveSyncStatus {
  final Status status;
  final int totalRecipes;
  final int currentRecipeNumber;
  final String recipeName;

  DriveSyncStatus(
    this.status,
    this.totalRecipes,
    this.currentRecipeNumber,
    this.recipeName,
  );
}

class GDriveSync {
  Map<String, Map<String, DateTime>>? driveModificationHistory;
  signIn.GoogleSignInAccount? driveAccount;
  String? jsonModificationId;
  signIn.GoogleSignIn? googleSignIn = signIn.GoogleSignIn.standard(scopes: [
    GD.DriveApi.driveAppdataScope
  ]); // .driveFileScope for public access
  FlutterSecureStorage? storage;

  GDriveSync._();
  static final GDriveSync gD = GDriveSync._();

  /// signs in the user to google drive
  Future<signIn.GoogleSignInAccount?> signInGDrive() async {
    googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [GD.DriveApi.driveAppdataScope]);

    try {
      driveAccount = await googleSignIn!.signIn();
      print(await googleSignIn!.requestScopes([GD.DriveApi.driveAppdataScope]));
    } catch (e) {}

    if (driveAccount != null) {
      // not used but if silentSignIn is not working, check how to use it
      signIn.GoogleSignInAuthentication authentication =
          await driveAccount!.authentication;
      authentication.accessToken;

      storage ??= new FlutterSecureStorage();
      await storage!.write(key: 'signedIn', value: "true");
    }

    return driveAccount;
  }

  Future<signIn.GoogleSignInAccount?> signInSilently() async {
    try {
      googleSignIn =
          signIn.GoogleSignIn.standard(scopes: [GD.DriveApi.driveAppdataScope]);
      storage ??= new FlutterSecureStorage();
      String? signedIn = await storage!.read(key: 'signedIn');

      if (signedIn == "true") {
        final signIn.GoogleSignInAccount? account = await googleSignIn!
            .signInSilently(suppressErrors: false); // TODO: check if works
        return account;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  /// signs out the user from google drive
  Future<void> signOutFromGoogle() async {
    if (googleSignIn != null) {
      await googleSignIn!.signOut();

      storage ??= new FlutterSecureStorage();
      await storage!.write(key: 'signedIn', value: "false");
    }
  }

  Future<GD.DriveApi> getDriveApi() async {
    signIn.GoogleSignInAccount? account = driveAccount ?? await signInGDrive();

    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = GD.DriveApi(authenticateClient);

    return driveApi;
  }

  /// signs in to google drive and then syncs all the recipes with the online
  /// recipes accordingly (including updating the deletions)
  Stream<DriveSyncStatus> synchornizeGDrive() async* {
    var driveMods = await getRecipeModificationsFromDrive();
    driveModificationHistory = driveMods.item2;
    jsonModificationId = driveMods.item1;

    var localMods = await getLocalModifications();
    List<List<String>> updateProcess =
        getUpdateListsFromModifications(localMods, driveModificationHistory!);

    int recipeCount = 0;
    for (String recipeName in updateProcess[0]) {
      yield DriveSyncStatus(
        Status.DELETED_LOCAL,
        updateProcess[0].length,
        recipeCount,
        recipeName,
      );
      recipeCount = recipeCount + 1;

      await HiveProvider().deleteRecipe(recipeName,
          deletionDate: driveMods.item2[recipeName]!['-'].toString());
      Future.delayed(Duration(milliseconds: 60)).then((_) async {
        await IO.deleteRecipeData(recipeName);
      });
    }

    recipeCount = 0;
    for (String recipeName in updateProcess[1]) {
      yield DriveSyncStatus(
        Status.DELETED_ONLINE,
        updateProcess[1].length,
        recipeCount,
        recipeName,
      );
      recipeCount = recipeCount + 1;

      await deleteGDriveRecipeIfExists(
          recipeName, HiveProvider().getDeletionDate(recipeName));
    }

    recipeCount = 0;
    for (String recipeName in updateProcess[2]) {
      yield DriveSyncStatus(
        Status.IMPORTED_LOCAL,
        updateProcess[2].length,
        recipeCount,
        recipeName,
      );
      recipeCount = recipeCount + 1;

      await importRecipeFromGDrive(recipeName);
    }

    recipeCount = 0;
    for (String recipeName in updateProcess[3]) {
      yield DriveSyncStatus(
        Status.UPLOADED,
        updateProcess[3].length,
        recipeCount,
        recipeName,
      );
      recipeCount = recipeCount + 1;

      await addGDriveRecipe(recipeName);
    }

    yield DriveSyncStatus(Status.FINISHED, 0, 0, "");
  }

  /// returns the map with the modifications, when which recipe was deleted or
  /// added to the local recipes
  Future<Map<String, Map<String, DateTime>>> getLocalModifications() async {
    Map<String, Map<String, DateTime>> localMods = {};

    HiveProvider().getDeletions().forEach((recipeName, delDate) {
      localMods.addAll({
        recipeName: {'-': delDate}
      });
    });

    for (String recipeName in HiveProvider().getRecipeNames()) {
      Recipe? recipe = await HiveProvider().getRecipeByName(recipeName);

      // if the recipe exists, which should always be the case
      if (recipe != null) {
        localMods.addAll({
          recipeName: {'+': DateTime.parse(recipe.lastModified)}
        });
      } // delete the recipe otherwise becaue it would just be causing issues
      else {
        await HiveProvider().deleteRecipe(recipeName);
      }
    }

    return localMods;
  }

  /// (currently not used) filters the given modification map, such that it only
  /// contains deleted or added recipes with the corresponding date
  Map<String, DateTime> getFilteredModHistory(
      Map<String, Map<String, DateTime>> modsMap, String sign) {
    assert(driveModificationHistory != null);
    Map<String, DateTime> mapFiltered = {};

    for (var recipeName in modsMap.keys) {
      if (modsMap[recipeName]!.containsKey(sign)) {
        mapFiltered[recipeName] = modsMap[recipeName]![sign]!;
      }
    }

    return mapFiltered;
  }

  /// imports the recipe, with the given recipeName from Gdrive, if it exists
  Future<String> importRecipeFromGDrive(String recipeName) async {
    String cRecipeName = stringReplaceSpaceUnderscore(recipeName);
    Tuple2<String?, File?>? downloadedRecipeZip =
        await getFileByName(cRecipeName + ".zip");

    if (downloadedRecipeZip != null) {
      Map<String, Recipe?> recipeImport =
          await IO.importRecipeToTmp(downloadedRecipeZip.item2!, true);

      await IO.importRecipeFromTmp(recipeImport[recipeImport.keys.first]!);

      await HiveProvider().saveRecipe(recipeImport[recipeImport.keys.first]!);

      return "success"; // TODO: better use enum
    } else {
      /// TODO: Maybe delete the recipe, if it was not found? Could be problematic
      /// if the download value is also sometimes null, if it fails, due to the
      /// internet connection but should not be the case
      return "failed";
    }

    // TODO: add failing cases
  }

  /// first updates the modification map on gdrive with the deletion entry and then deletes
  /// the recipe file of the given recipe
  Future<void> deleteGDriveRecipeIfExists(
      String recipeName, DateTime? deletionDate) async {
    assert(driveModificationHistory != null);

    // Add a deletion entry to the modifications map
    if (deletionDate != null) {
      driveModificationHistory![recipeName] = {"-": deletionDate};

      await updateDriveModifications();
    }

    String recipeFolder =
        (await PathProvider.pP.getRecipeDirFull(recipeName)).split('/').last;
    await deleteFileDriveIfExists(recipeFolder + ".zip");
    print("successfully delete $recipeName");
  }

  /// gets the file by name from Gdrive and returns it if found. Ohterwise returns
  /// null
  Future<Tuple2<String?, File?>?> getFileByName(String fileName) async {
    // Get the Google Drive API client
    var driveApi = await getDriveApi();

    // Search for the file named 'recipes'
    var searchFiles = (await driveApi.files
            .list(spaces: 'appDataFolder', q: "name='$fileName'"))
        .files;

    // If the file is found, download it and save it as a local file
    if (searchFiles != null && searchFiles.isNotEmpty) {
      var file = searchFiles.first;
      var fileId = file.id;

      // Download the file using its ID and save it as a local file
      GD.Media fileStream = (await driveApi.files.get(fileId!,
          downloadOptions: DownloadOptions.fullMedia)) as GD.Media;
      final File finalFile =
          File(await PathProvider.pP.getTmpRecipeDir() + fileName);

      List<int> dataStore = [];
      Completer<void> _completer = Completer<void>();

      fileStream.stream.listen(
        (data) {
          print("DataReceived: ${data.length}");
          dataStore.insertAll(dataStore.length, data);
        },
        onDone: () {
          print("Task Done");
          finalFile.writeAsBytes(dataStore).then((_) {
            print("File saved at ${finalFile.path}");
            _completer.complete();
          });
        },
        onError: (error) {
          print("Some Error");
          _completer.completeError(error);
        },
      );

      // Execute the next line of code after the file is completely saved.
      await _completer.future;
      return Tuple2(fileId, finalFile);
    } else {
      // If the file is not found, return an empty map
      return null;
    }
  }

  /// given two modification files, returns lists, which recipes in which storage
  /// (e.g. cloud and local) have to be deleted or added to the other storage
  /// s.t. everything is up to date
  List<List<String>> getUpdateListsFromModifications(
      Map<String, Map<String, DateTime>> modsOne,
      Map<String, Map<String, DateTime>> modsTwo) {
    List<String> toDeleteInMap1 = [];
    List<String> toDeleteInMap2 = [];
    List<String> toUpdateInMap1 = [];
    List<String> toUpdateInMap2 = [];

    Set<String> recipeNames = {};
    recipeNames.addAll(modsOne.keys);
    recipeNames.addAll(modsTwo.keys);

    for (String recipeName in recipeNames) {
      DateTime? map1Time =
          modsOne[recipeName]?['+'] ?? modsOne[recipeName]?['-'];
      DateTime? map2Time =
          modsTwo[recipeName]?['+'] ?? modsTwo[recipeName]?['-'];

      if (map1Time != null && map2Time != null) {
        if (map1Time.isAfter(map2Time)) {
          if (modsOne[recipeName]!.containsKey('+')) {
            toDeleteInMap2.add(recipeName);
            toUpdateInMap2.add(recipeName);
          } else if (!(modsOne[recipeName]!.containsKey('-') &&
              modsTwo[recipeName]!.containsKey('-'))) {
            toDeleteInMap2.add(recipeName);
          }
        } else if (map1Time.isBefore(map2Time)) {
          if (modsTwo[recipeName]!.containsKey('+')) {
            toDeleteInMap1.add(recipeName);
            toUpdateInMap1.add(recipeName);
          } else if (!(modsOne[recipeName]!.containsKey('-') &&
              modsTwo[recipeName]!.containsKey('-'))) {
            toDeleteInMap1.add(recipeName);
          }
        }
      } else if (map1Time != null && map2Time == null) {
        if (modsOne[recipeName]!.containsKey('+')) {
          toUpdateInMap2.add(recipeName);
        }
      } else if (map1Time == null && map2Time != null) {
        if (modsTwo[recipeName]!.containsKey('+')) {
          toUpdateInMap1.add(recipeName);
        }
      }
    }

    return [toDeleteInMap1, toDeleteInMap2, toUpdateInMap1, toUpdateInMap2];
  }

  /// gets teh google drive modifications and returns a tuple where the first item
  /// is the gdrive id and the second the modificatinMap
  Future<Tuple2<String?, Map<String, Map<String, DateTime>>>>
      getRecipeModificationsFromDrive() async {
    Map<String, Map<String, DateTime>> recipeMap = {};
    String? fileId;

    Tuple2<String?, File?>? recipes = await getFileByName("recipes.json");

    // if the recipes.json does not exist, creat the file and upload it
    if (recipes == null) {
      driveModificationHistory = {};

      // Convert the updated map back to a JSON string
      var updatedJsonString = json.encode(driveModificationHistory);

      // Convert the JSON string to a byte list using UTF-8 encoding
      var updatedBytes = utf8.encode(updatedJsonString);

      // Create a Media object with the updated content
      var updatedMedia = Media(
        Stream.fromIterable([updatedBytes.cast<int>()]),
        updatedJsonString.length,
      );

      // Create a File object with the updated metadata
      var recipesJson = GD.File();
      recipesJson.name = 'recipes.json';
      recipesJson.parents = ["appDataFolder"];

      // Upload the file content in Google Drive
      var driveApi = await getDriveApi();
      GD.File modificationsJson =
          await driveApi.files.create(recipesJson, uploadMedia: updatedMedia);
      fileId = modificationsJson.id;
    } // otherwise, parse it
    else {
      if (recipes.item2 != null) {
        var jsonFile = await recipes.item2!.readAsString();
        fileId = recipes.item1;
        Map<String, dynamic> jsonMap = json.decode(jsonFile);
        print(jsonMap);

        recipeMap.addAll(jsonMap.map((key, value) {
          Map<String, DateTime> innerMap =
              (value as Map<String, dynamic>).map((innerKey, innerValue) {
            return MapEntry(innerKey, DateTime.parse(innerValue));
          });
          return MapEntry(key, innerMap);
        }));
      }
    }

    return Tuple2(fileId, recipeMap);
  }

  /// First adds the recipeZip to gdrive and then modifies the Modification File
  /// and uploads/updates it
  Future<void> addGDriveRecipe(String recipeName) async {
    assert(driveModificationHistory != null);

    Recipe? uploadRecipe = await HiveProvider().getRecipeByName(recipeName);
    if (uploadRecipe != null) {
      String recipeFolder =
          (await PathProvider.pP.getRecipeDirFull(recipeName)).split('/').last;
      await deleteFileDriveIfExists(recipeFolder + ".zip");
      // Save the recipe data to a ZIP file
      File recipeZip = File(await IO.saveRecipeZip(
          await PathProvider.pP.getTmpRecipeDir(), uploadRecipe.name));

      // Upload the recipe ZIP file to Google Drive
      await uploadFile(recipeZip.path.split('/').last, recipeZip, "zip");
      print('uploaded files for $recipeName');

      await File(await PathProvider.pP.getTmpRecipeDir())
          .delete(recursive: true);

      // Add an entry for the recipe to the modification history
      driveModificationHistory![uploadRecipe.name] = {
        '+': DateTime.parse(uploadRecipe.lastModified)
      };

      // Update the modification history in Google Drive
      await updateDriveModifications();
    }
  }

  /// uploads the modification file according to the driveModificationHistory
  /// global variable
  Future<void> updateDriveModifications() async {
    assert(jsonModificationId != null);

    Map<String, Map<String, String>> jsonMap = {};
    driveModificationHistory!.forEach((key, value) {
      jsonMap[key] = {};
      value.forEach((subkey, datetime) {
        jsonMap[key]![subkey] = datetime.toString();
      });
    });

    // Convert the updated map back to a JSON string
    var updatedJsonString = json.encode(jsonMap);

    // Convert the JSON string to a byte list using UTF-8 encoding
    var updatedBytes = utf8.encode(updatedJsonString);

    // Create a Media object with the updated content
    var updatedMedia = Media(
      Stream.fromIterable([updatedBytes.cast<int>()]),
      updatedBytes.length,
    );

    print(updatedJsonString.length);

    // Create a File object with the updated metadata
    var updateRequest = GD.File();
    updateRequest.name = 'recipes.json';

    // Update the file content in Google Drive
    var driveApi = await getDriveApi();
    await driveApi.files
        .update(updateRequest, jsonModificationId!, uploadMedia: updatedMedia);
  }

  /// deletes the gdrive file with the given filename
  Future<void> deleteFileDriveIfExists(String fileName) async {
    // Get the Google Drive API client
    var driveApi = await getDriveApi();

    // Search for the file named 'recipes'
    var searchFiles = (await driveApi.files
            .list(spaces: 'appDataFolder', q: "name='$fileName'"))
        .files;

    // If the file is found, delete it
    if (searchFiles!.isNotEmpty) {
      var file = searchFiles.first;
      var fileId = file.id;

      await driveApi.files.delete(fileId!);
      print("deleted file $fileName");
    }
  }

  /// uploads the given file with its information and returns the file id
  Future<String?> uploadFile(
      String fileName, File uploadFile, String fileEnding) async {
    // Read the file data as a byte list
    final Uint8List fileData = await uploadFile.readAsBytes();

    // Create a Media object with the file data and content type
    final media = GD.Media(
      http.ByteStream.fromBytes(fileData),
      fileData.length,
      contentType: "application/$fileEnding",
    );

    // Create a new File object with the file name
    var driveFile = new GD.File();
    driveFile.name = uploadFile.path.split('/').last;
    driveFile.parents = ["appDataFolder"];

    // Upload the file to Google Drive and return the file ID
    var driveApi = await getDriveApi();
    GD.File result = await driveApi.files.create(driveFile, uploadMedia: media);
    return result.id;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

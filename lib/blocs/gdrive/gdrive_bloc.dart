import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:my_recipe_book/local_storage/io_operations.dart' as IO;
import 'package:my_recipe_book/local_storage/local_paths.dart';
import 'package:path/path.dart' as p;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:my_recipe_book/util/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

part 'gdrive_event.dart';
part 'gdrive_state.dart';

// TODO: update and put in seperate gitignore file
const _clientId = "CLIENT_ID";
const _clientSecret = "CLIENT_SECRET";
const _scopes = [ga.DriveApi.DriveFileScope];

class GdriveBloc extends Bloc<GdriveEvent, GdriveState> {
  final storage = SecureStorage();
  AutoRefreshingAuthClient _authClient;

  GdriveBloc() : super(GdriveInitial());

  @override
  Stream<GdriveState> mapEventToState(
    GdriveEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  _mapAuthenticateToState() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(_clientId, _clientSecret), _scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      _authClient = authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      _authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken(credentials["type"], credentials["data"],
              DateTime.tryParse(credentials["expiry"])),
          credentials["refreshToken"],
          _scopes,
        ),
      );
    }
  }

  _mapAddRecipeToState(String recipeName) async {
    var drive = ga.DriveApi(_authClient);
    File zip = File(await IO.saveRecipeZip(
        await PathProvider.pP.getShareDir(), recipeName));
    print("Uploading file");
    var response = await drive.files.create(
        ga.File()..name = p.basename(zip.absolute.path),
        uploadMedia: ga.Media(zip.openRead(), zip.lengthSync()));

    print("Result ${response.toJson()}");
  }
}

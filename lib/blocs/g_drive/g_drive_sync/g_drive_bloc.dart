import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_recipe_book/blocs/recipe_mods/recipe_mods_bloc.dart';
import 'package:my_recipe_book/network_storage/g_drive_sync.dart';

import '../../recipe_category_overview/recipe_category_overview_bloc.dart';
import '../g_drive_sign_in/g_drive_sign_in_bloc.dart';

part 'g_drive_event.dart';
part 'g_drive_state.dart';

class GDriveSyncBloc extends Bloc<GDriveSyncEvent, GDriveSyncState> {
  late StreamSubscription<DriveSyncStatus> listener;
  final BuildContext context;

  GDriveSyncBloc(this.context) : super(GDriveIdle()) {
    on<GDriveStartSync>((event, emit) async {
      emit(GDriveSyncing());
      BlocProvider.of<RecipeModsBloc>(context).add(BlockMods());

      listener = GDriveSync.gD.synchornizeGDrive().listen((i) async {
        switch (i.status) {
          case Status.DELETED_LOCAL:
            add(InternGDriveLocalDeletingEvent(
              i.recipeName,
              i.currentRecipeNumber,
              i.totalRecipes,
            ));
            break;
          case Status.DELETED_ONLINE:
            add(InternGDriveCloudDeletingEvent(
              i.recipeName,
              i.currentRecipeNumber,
              i.totalRecipes,
            ));
            break;
          case Status.IMPORTED_LOCAL:
            add(InternGDriveImportingEvent(
              i.recipeName,
              i.currentRecipeNumber,
              i.totalRecipes,
            ));
            break;
          case Status.UPLOADED:
            add(InternGDriveUploadingEvent(
              i.recipeName,
              i.currentRecipeNumber,
              i.totalRecipes,
            ));
            break;
          case Status.FINISHED:
            await Future.delayed(Duration(milliseconds: 200));
            add(InternGDriveSuccessfullySyncedEvent());
            await cancelStream();
            BlocProvider.of<RecipeModsBloc>(context).add(UnblockMods());
            break;
          default:
        }
      });
    });

    on<InternGDriveCloudDeletingEvent>((event, emit) async {
      emit(GDriveCloudDeleting(
          event.recipeName, event.deletingRecipeNumber, event.totalDeleting));
    });

    on<InternGDriveImportingEvent>((event, emit) async {
      reloadRecipeOverview();
      emit(GDriveImporting(
          event.recipeName, event.importingRecipeNumber, event.totalImporting));
    });

    on<InternGDriveLocalDeletingEvent>((event, emit) async {
      reloadRecipeOverview();
      emit(GDriveLocalDeleting(
          event.recipeName, event.deletingRecipeNumber, event.totalDeleting));
    });

    on<InternGDriveUploadingEvent>((event, emit) async {
      emit(GDriveUploading(
          event.recipeName, event.uploadingRecipeNumber, event.totalUploading));
    });

    on<InternGDriveSuccessfullySyncedEvent>((event, emit) async {
      emit(GDriveSuccessfullySynced());
    });

    on<InternGDriveIdleEvent>((event, emit) async {
      emit(GDriveIdle());
    });

    on<GDriveCancelSync>((event, emit) async {
      emit(GDriveCancellingSync());
      await cancelStream();
      emit(GDriveIdle());
    });
  }

  Future<void> cancelStream() async {
    await listener.cancel();
  }

  void reloadRecipeOverview() {
    BlocProvider.of<RecipeCategoryOverviewBloc>(context).add(
        RCOLoadRecipeCategoryOverview(
            reopenBoxes: false, categoryOverviewContext: context));
  }
}

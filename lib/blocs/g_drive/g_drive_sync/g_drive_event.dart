part of 'g_drive_bloc.dart';

abstract class GDriveSyncEvent extends Equatable {
  const GDriveSyncEvent();
}

class InternGDriveImportingEvent extends GDriveSyncEvent {
  final String recipeName;
  final int importingRecipeNumber;
  final int totalImporting;

  InternGDriveImportingEvent(
    this.recipeName,
    this.importingRecipeNumber,
    this.totalImporting,
  );

  @override
  List<Object?> get props => [
        recipeName,
        importingRecipeNumber,
        totalImporting,
      ];
}

class InternGDriveUploadingEvent extends GDriveSyncEvent {
  final String recipeName;
  final int uploadingRecipeNumber;
  final int totalUploading;

  InternGDriveUploadingEvent(
    this.recipeName,
    this.uploadingRecipeNumber,
    this.totalUploading,
  );

  @override
  List<Object?> get props => [
        recipeName,
        uploadingRecipeNumber,
        totalUploading,
      ];
}

class InternGDriveCloudDeletingEvent extends GDriveSyncEvent {
  final String recipeName;
  final int deletingRecipeNumber;
  final int totalDeleting;

  InternGDriveCloudDeletingEvent(
    this.recipeName,
    this.deletingRecipeNumber,
    this.totalDeleting,
  );

  @override
  List<Object?> get props => [
        recipeName,
        deletingRecipeNumber,
        totalDeleting,
      ];
}

class InternGDriveLocalDeletingEvent extends GDriveSyncEvent {
  final String recipeName;
  final int deletingRecipeNumber;
  final int totalDeleting;

  InternGDriveLocalDeletingEvent(
    this.recipeName,
    this.deletingRecipeNumber,
    this.totalDeleting,
  );

  @override
  List<Object?> get props => [
        recipeName,
        deletingRecipeNumber,
        totalDeleting,
      ];
}

class GDriveCancelSync extends GDriveSyncEvent {
  GDriveCancelSync();

  @override
  List<Object> get props => [];
}

class InternGDriveSuccessfullySyncedEvent extends GDriveSyncEvent {
  InternGDriveSuccessfullySyncedEvent();

  @override
  List<Object> get props => [];
}

class InternGDriveIdleEvent extends GDriveSyncEvent {
  InternGDriveIdleEvent();

  @override
  List<Object> get props => [];
}

class GDriveStartSync extends GDriveSyncEvent {
  final DateTime time;

  GDriveStartSync(this.time);

  @override
  List<Object> get props => [time];
}

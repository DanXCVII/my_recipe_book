part of 'g_drive_bloc.dart';

abstract class GDriveSyncState extends Equatable {
  const GDriveSyncState();
}

class GDriveIdle extends GDriveSyncState {
  @override
  List<Object?> get props => [];
}

class GDriveSyncing extends GDriveSyncState {
  @override
  List<Object?> get props => [];
}

class GDriveImporting extends GDriveSyncState {
  final String recipeName;
  final int importingRecipeNumber;
  final int totalImporting;

  GDriveImporting(
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

class GDriveUploading extends GDriveSyncState {
  final String recipeName;
  final int uploadingRecipeNumber;
  final int totalUploading;

  GDriveUploading(
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

class GDriveCloudDeleting extends GDriveSyncState {
  final String recipeName;
  final int deletingRecipeNumber;
  final int totalDeleting;

  GDriveCloudDeleting(
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

class GDriveLocalDeleting extends GDriveSyncState {
  final String recipeName;
  final int deletingRecipeNumber;
  final int totalDeleting;

  GDriveLocalDeleting(
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

class GDriveSuccessfullySynced extends GDriveSyncState {
  @override
  List<Object?> get props => [];
}

class GDriveCancellingSync extends GDriveSyncState {
  @override
  List<Object?> get props => [];
}

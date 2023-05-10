part of 'g_drive_sign_in_bloc.dart';

abstract class GDriveSignInEvent extends Equatable {
  const GDriveSignInEvent();

  @override
  List<Object> get props => [];
}

class GDriveSignIn extends GDriveSignInEvent {
  GDriveSignIn();

  @override
  List<Object> get props => [];
}

class GDriveSilentSignIn extends GDriveSignInEvent {
  GDriveSilentSignIn();

  @override
  List<Object> get props => [];
}

class GDriveSignOut extends GDriveSignInEvent {
  GDriveSignOut();

  @override
  List<Object> get props => [];
}

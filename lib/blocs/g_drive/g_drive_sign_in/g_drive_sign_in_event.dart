part of 'g_drive_sign_in_bloc.dart';

abstract class GDriveSignInEvent {
  const GDriveSignInEvent();
}

class GDriveSignIn extends GDriveSignInEvent {
  GDriveSignIn();
}

class GDriveSilentSignIn extends GDriveSignInEvent {
  GDriveSilentSignIn();
}

class GDriveSignOut extends GDriveSignInEvent {
  GDriveSignOut();
}

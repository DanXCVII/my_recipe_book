part of 'g_drive_sign_in_bloc.dart';

abstract class GDriveSignInState extends Equatable {
  const GDriveSignInState();
}

class GDriveSignedIn extends GDriveSignInState {
  final String signedInName;
  final String signedInEmail;
  final String? imageUrl;

  GDriveSignedIn(this.signedInName, this.signedInEmail, this.imageUrl);

  @override
  List<Object?> get props => [signedInName, signedInEmail, imageUrl];
}

class GDriveSigningIn extends GDriveSignInState {
  @override
  List<Object?> get props => [];
}

class GDriveSigningOut extends GDriveSignInState {
  @override
  List<Object?> get props => [];
}

class GDriveSignedOut extends GDriveSignInState {
  @override
  List<Object?> get props => [];
}

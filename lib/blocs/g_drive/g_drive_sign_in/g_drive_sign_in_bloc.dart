import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../network_storage/g_drive_sync.dart';

part 'g_drive_sign_in_event.dart';
part 'g_drive_sign_in_state.dart';

class GDriveSignInBloc extends Bloc<GDriveSignInEvent, GDriveSignInState> {
  GDriveSignInBloc() : super(GDriveSignedOut()) {
    on<GDriveSignInEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GDriveSignIn>((event, emit) async {
      GoogleSignInAccount? account = await GDriveSync.gD.signInGDrive();
      if (account != null) {
        emit(GDriveSignedIn(
          account.displayName ?? "",
          account.email,
          account.photoUrl,
        ));
      } else {
        // TODO: case login failed
      }
    });

    on<GDriveSilentSignIn>((event, emit) async {
      emit(GDriveSigningIn());
      GoogleSignInAccount? account = await GDriveSync.gD.signInSilently();
      if (account != null) {
        emit(GDriveSignedIn(
          account.displayName ?? "",
          account.email,
          account.photoUrl,
        ));
      } else {
        emit(GDriveSignedOut());
      }
    });

    on<GDriveSignOut>((event, emit) async {
      emit(GDriveSigningOut());
      await GDriveSync.gD.signOutFromGoogle();
      emit(GDriveSignedOut());
    });
  }
}

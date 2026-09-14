import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../network_storage/g_drive_sync.dart';

part 'g_drive_sign_in_event.dart';
part 'g_drive_sign_in_state.dart';

class GDriveSignInBloc extends Bloc<GDriveSignInEvent, GDriveSignInState> {
  GDriveSignInBloc(this.driveSync) : super(GDriveSignedOut()) {
    on<GDriveSignInEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GDriveSignIn>((event, emit) async {
      emit(GDriveSigningIn());

      bool connectedToInternet = await checkInternet();
      if (connectedToInternet) {
        GoogleSignInAccount? account = await driveSync.signInGDrive();
        if (account != null) {
          emit(GDriveSignedIn(
            account.displayName ?? "",
            account.email,
            account.photoUrl,
          ));
        } else {
          emit(GDriveNoInternet());
        }
      } else {
        emit(GDriveNoInternet());
      }
    });

    on<GDriveSilentSignIn>((event, emit) async {
      emit(GDriveSigningIn());

      bool connectedToInternet = await checkInternet();
      if (connectedToInternet) {
        GoogleSignInAccount? account = await driveSync.signInSilently();
        if (account != null) {
          emit(GDriveSignedIn(
            account.displayName ?? "",
            account.email,
            account.photoUrl,
          ));
        } else {
          emit(GDriveSignedOut());
        }
      } else {
        emit(GDriveNoInternet());
      }
    });

    on<GDriveSignOut>((event, emit) async {
      emit(GDriveSigningOut());
      await driveSync.signOutFromGoogle();
      emit(GDriveSignedOut());
    });
  }

  final GDriveSync driveSync;

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

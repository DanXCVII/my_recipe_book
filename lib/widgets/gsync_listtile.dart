import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/g_drive/g_drive_sign_in/g_drive_sign_in_bloc.dart';
import '../blocs/g_drive/g_drive_sync/g_drive_bloc.dart';
import '../generated/i18n.dart';

class GSyncListtile extends StatelessWidget {
  const GSyncListtile({super.key});

  /// animated height with at the top, the sign in status and the bottom
  /// the progress of the syncing etc.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GDriveSignInBloc, GDriveSignInState>(
        builder: (context, state) {
      if (state is GDriveSignedIn) {
        String? iUrl = state.imageUrl;
        return Container(
          decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: iUrl == null
                    ? Icon(Icons.account_circle)
                    : Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image.network(iUrl),
                      ),
                trailing: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    BlocProvider.of<GDriveSignInBloc>(context)
                        .add(GDriveSignOut());
                  },
                ),
                title: Text(state.signedInName),
                subtitle: Text(state.signedInEmail),
              ),
              BlocBuilder<GDriveSyncBloc, GDriveSyncState>(
                  builder: (context, state) {
                if (state is GDriveIdle) {
                  return ListTile(
                    onTap: () {
                      BlocProvider.of<GDriveSyncBloc>(context)
                          .add(GDriveStartSync(DateTime.now()));
                    },
                    leading: Icon(Icons.cloud_sync),
                    title: Text(I18n.of(context)!.sync_recipes_drive),
                  );
                } else if (state is GDriveSyncing) {
                  return ListTile(
                    leading: Icon(Icons.sync),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveCancelSync());
                      },
                    ),
                    title: LinearProgressIndicator(value: 0),
                    subtitle: Text(I18n.of(context)!.syncing_recipes_drive),
                  );
                } else if (state is GDriveImporting) {
                  return ListTile(
                    leading: Icon(Icons.cloud_download),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveCancelSync());
                      },
                    ),
                    title: LinearProgressIndicator(
                        value:
                            state.importingRecipeNumber / state.totalImporting),
                    subtitle: Text(I18n.of(context)!
                        .importing_recipe_drive(state.recipeName)),
                  );
                } else if (state is GDriveUploading) {
                  double progress =
                      state.uploadingRecipeNumber / state.totalUploading;
                  return ListTile(
                    leading: Icon(Icons.cloud_upload),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveCancelSync());
                      },
                    ),
                    title: LinearProgressIndicator(value: progress),
                    subtitle: Text(I18n.of(context)!
                        .uploading_recipe_drive(state.recipeName)),
                  );
                } else if (state is GDriveCloudDeleting) {
                  return ListTile(
                    leading: Icon(Icons.cloud_upload),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveCancelSync());
                      },
                    ),
                    title: LinearProgressIndicator(
                        value:
                            state.deletingRecipeNumber / state.totalDeleting),
                    subtitle: Text(I18n.of(context)!
                        .deleting_recipe_drive(state.recipeName)),
                  );
                } else if (state is GDriveLocalDeleting) {
                  return ListTile(
                    leading: Icon(Icons.cloud_download),
                    trailing: IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveCancelSync());
                      },
                    ),
                    title: LinearProgressIndicator(
                        value:
                            state.deletingRecipeNumber / state.totalDeleting),
                    subtitle: Text(I18n.of(context)!
                        .deleting_recipe_local(state.recipeName)),
                  );
                } else if (state is GDriveCancellingSync) {
                  return ListTile(
                    leading: Icon(Icons.cloud_download),
                    trailing: Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator()),
                    title: Text("Cancelling Sync"),
                  );
                } else if (state is GDriveSuccessfullySynced) {
                  return ListTile(
                    leading: Icon(Icons.cloud_done),
                    title: Text(I18n.of(context)!.successfully_synced_drive),
                    trailing: IconButton(
                      icon: Icon(Icons.sync),
                      onPressed: () {
                        BlocProvider.of<GDriveSyncBloc>(context)
                            .add(GDriveStartSync(DateTime.now()));
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        );
      } else if (state is GDriveSignedOut) {
        return Column(
          children: [
            ListTile(
              leading: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Image.asset("images/google_logo.png"),
              ),
              title: Text(I18n.of(context)!.sync_recipes_drive),
              onTap: () {
                BlocProvider.of<GDriveSignInBloc>(context).add(GDriveSignIn());
              },
            ),
            Divider(),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

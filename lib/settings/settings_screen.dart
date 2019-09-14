import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_recipe_book/models/recipe_keeper.dart';
import 'package:scoped_model/scoped_model.dart';
import '../intro_screen.dart';
import '../theming.dart';
import './import_recipe.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ScopedModelDescendant<RecipeKeeper>(
            builder: (context, child, model) => GestureDetector(
              onTap: () {
                _importSingleRecipe(model).then((_) {});
              },
              child: ListTile(
                title: Text('import Recipe'),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('switch to dark theme'),
            trailing: Container(
              width: 100,
              height: 25,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.LIGHT);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Color(0xffFEF3E1),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.DARK);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Color(0xff454545),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _changeTheme(context, MyThemeKeys.OLEDBLACK);
                      });
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).textTheme.body1.color),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('view intro'),
            onTap: () {
              SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => IntroScreen(
                      true))); // TODO: recipeCategoryOverview not always true!
            },
          ),
          Divider(),
          ListTile(title: Text('about me')),
          Divider(),
          ListTile(title: Text('rate this app')),
          Divider(),
        ],
      ),
    );
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    print(key.toString());
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  Future<void> _importSingleRecipe(RecipeKeeper rKeeper) async {
    // Let the user select the .zip file
    String _path = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: 'zip');
    if (_path == null) return;
    importRecipe(rKeeper, _path);
  }
}

import 'package:flutter/material.dart';
import 'dart:io';

/// Models:

/// Screens:

/// Widgets:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

/// Services:

/// State:

/// Utils/Helpers:
import 'package:responsive_builder/responsive_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:docx_template/docx_template.dart';

/// Entry Point:
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  final dataDir = Directory.current.path;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    windowManager.addListener(this);
    // createRequiredFolders();
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> createRequiredFolders() async {
    final Directory dataDirFolder = Directory('$dataDir\\data\\');
    final File myFile = File('$dataDir\\data\\fee_structure.docx');
  }

  Future<void> saveFileToDisk() async {
    final f = File('$dataDir\\data\\fee_structure.docx');
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    Content c = Content();

    c..add(TextContent("r", "2019-cs-20"));

    final d = await docx.generate(c);
    final of = File("test.docx");

    if (d != null) {
      await of.writeAsBytes(d);
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    Future<void> onWindowFocus() async {
      // Make sure to call once for Window to show when maximized.
      setState(() {});
    }

    return Scaffold(
      body: SafeArea(
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) {
            return OrientationLayoutBuilder(
              // Force a screen to stay in portrait/landscape. Overrides the OrientationLayoutBuilder
              // mode: OrientationLayoutBuilderMode.portrait,
              portrait: (context) => Container(),
              landscape: (context) => Container(),
            );
          },
          tablet: (BuildContext context) {
            return OrientationLayoutBuilder(
              portrait: (context) => Container(),
              landscape: (context) => Container(),
            );
          },
          desktop: (BuildContext context) => Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FormBuilder(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormBuilderTextField(
                            name: 'roll',
                            decoration: InputDecoration(
                              labelText: 'Roll Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.004,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

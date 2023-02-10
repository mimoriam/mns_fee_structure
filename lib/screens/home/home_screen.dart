import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';

/// Models:

/// Screens:
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:go_router/go_router.dart';

/// Widgets:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

/// Services:

/// State:

/// Utils/Helpers:
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:docx_template/docx_template.dart';
import 'package:number_to_character/number_to_character.dart';
import 'package:collection/collection.dart';

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

/// Entry Point:
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      duration: 800,
      splash: "images/logo.png",
      screenFunction: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
        return const HomeScreen();
      },
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.blue,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  final dataDir = Directory.current.path;
  final _formKey = GlobalKey<FormBuilderState>();

  final successSnackBar = const SnackBar(content: Text('File saved'));
  final failedSnackBar =
      const SnackBar(content: Text('Failed. Please input all values!'));

  String morningEveningDropDown = 'Morning';
  String sem = 'Semester: 1st';

  List<int> totalCalc = [];

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> saveFileToDisk() async {
    final f = File('$dataDir\\data\\fee_structure.docx');
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(_formKey.currentState?.fields['ld']?.value);
    String formattedDashedDate = DateFormat('yyyy-MM-dd').format(now);

    //
    var converter = NumberToCharacterConverter('en');
    // var v = converter
    //     .convertInt(int.parse(_formKey.currentState?.fields['amount']?.value));

    var v = converter.convertInt(int.parse("5000"));

    Content c = Content();
    c
      ..add(TextContent('c', _formKey.currentState?.fields['c']?.value))
      ..add(TextContent('ld', formattedDate))
      ..add(TextContent('r', _formKey.currentState?.fields['r']?.value))
      ..add(TextContent('n', _formKey.currentState?.fields['n']?.value))
      ..add(TextContent('cnic', _formKey.currentState?.fields['cnic']?.value))
      ..add(TextContent('rd', _formKey.currentState?.fields['rd']?.value));

    if (morningEveningDropDown == 'Morning') {
      c.add(TextContent('rdme', 'M'));
    } else {
      c.add(TextContent('rdme', 'E'));
    }

    c
      ..add(TextContent('sem', sem.substring(10, 13)))
      ..add(TextContent('sess', _formKey.currentState?.fields['sess']?.value))
      ..add(TextContent('adf', _formKey.currentState?.fields['adf']?.value))
      ..add(TextContent('unr', _formKey.currentState?.fields['unr']?.value))
      ..add(TextContent('uns', _formKey.currentState?.fields['uns']?.value))
      ..add(TextContent('lis', _formKey.currentState?.fields['lis']?.value))
      ..add(TextContent('dev', _formKey.currentState?.fields['dev']?.value))
      ..add(TextContent('emr', _formKey.currentState?.fields['emr']?.value))
      ..add(TextContent('tuf', _formKey.currentState?.fields['tuf']?.value))
      ..add(TextContent('trf', _formKey.currentState?.fields['trf']?.value))
      ..add(TextContent('spf', _formKey.currentState?.fields['spf']?.value))
      ..add(TextContent('laf', _formKey.currentState?.fields['laf']?.value))
      ..add(TextContent('tutf', _formKey.currentState?.fields['tutf']?.value))
      ..add(TextContent('inutf', _formKey.currentState?.fields['inutf']?.value))
      ..add(TextContent('maf', _formKey.currentState?.fields['maf']?.value))
      ..add(TextContent('medf', _formKey.currentState?.fields['medf']?.value))
      ..add(TextContent('examf', _formKey.currentState?.fields['examf']?.value))
      ..add(TextContent(
          'internetf', _formKey.currentState?.fields['internetf']?.value))
      ..add(TextContent('total', totalCalc.sum));

    final d = await docx.generate(c);
    final of = File(
        "exports\\${formattedDashedDate}_${_formKey.currentState?.fields['r']?.value}.docx");

    if (d != null) {
      await of.writeAsBytes(d);
    }
  }

  @override
  Widget build(BuildContext context) {
    @override
    Future<void> onWindowFocus() async => setState(() {});

    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: FormBuilder(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // rgb(38, 40, 149)
                          height: MediaQuery.of(context).size.height * 0.08,
                          // height: 50,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(38, 40, 149, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(80.0),
                              bottomRight: Radius.circular(80.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('images/logo.png'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              Text(
                                "Muhammad Nawaz Sharif \nUniversity of Engineering\n & Technology, Multan",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.010,
                                  // fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                keyboardType: TextInputType.number,
                                name: 'c',
                                decoration: const InputDecoration(
                                  labelText: 'Challan No.',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'r',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Roll No.',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                name: 'ld',
                                format: DateFormat('dd-MM-yyyy'),
                                enabled: true,
                                inputType: InputType.date,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Last Date for Submission',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'n',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Name of Student',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                keyboardType: TextInputType.number,
                                name: 'cnic',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'CNIC',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'rd',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Department/Program',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'sess',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Session/Year (2016-2020)',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                              ),
                              child: DropdownButton<String>(
                                value: morningEveningDropDown,
                                underline: const SizedBox(),
                                items: <String>[
                                  'Morning',
                                  'Evening'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    morningEveningDropDown = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                              ),
                              child: DropdownButton<String>(
                                value: sem,
                                underline: const SizedBox(),
                                items: <String>[
                                  'Semester: 1st',
                                  'Semester: 2nd',
                                  'Semester: 3rd',
                                  'Semester: 4th',
                                  'Semester: 5th',
                                  'Semester: 6th',
                                  'Semester: 7th',
                                  'Semester: 8th',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sem = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'adf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Admission Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'unr',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'University Registration',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'uns',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'University Security',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'lis',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Library Security',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'dev',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Degree Verification',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'emr',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Email Registration',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'tuf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Tuition Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'trf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Transportation Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'spf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Sports Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'laf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Lab Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'tutf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Tutorial Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'inutf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Inter-Uni Tournament Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'maf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Magazine Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'medf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Medical Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'examf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Examination Fee',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.004,
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'internetf',
                                keyboardType: TextInputType.number,
                                initialValue: '0',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.numeric(),
                                ]),
                                decoration: const InputDecoration(
                                  labelText: 'Internet Charges',
                                  filled: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _formKey.currentState?.save();
                            if (_formKey.currentState!.validate()) {
                              saveFileToDisk();

                              // _formKey.currentState?.reset();
                              // FocusScope.of(context).unfocus();

                              totalCalc.clear();
                              totalCalc.addAll([
                                int.parse(_formKey
                                    .currentState?.fields['adf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['unr']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['uns']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['lis']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['dev']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['emr']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['tuf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['trf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['spf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['laf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['tutf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['inutf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['maf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['medf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['examf']?.value),
                                int.parse(_formKey
                                    .currentState?.fields['internetf']?.value),
                              ]);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(successSnackBar);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(failedSnackBar);
                            }
                          },
                          child: const Text("Submit"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

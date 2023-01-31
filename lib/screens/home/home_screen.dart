import 'package:flutter/material.dart';
import 'dart:io';

/// Models:

/// Screens:

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
// import 'package:syncfusion_flutter_pdf/pdf.dart';

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

/// Entry Point:
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

  Future<void> createRequiredFolders() async {
    final Directory dataDirFolder = Directory('$dataDir\\data\\');
    final File myFile = File('$dataDir\\data\\fee_structure.docx');
  }

  Future<void> saveFileToDisk() async {
    final f = File('$dataDir\\data\\fee_structure.docx');
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedDashedDate = DateFormat('yyyy-MM-dd').format(now);

    var converter = NumberToCharacterConverter('en');
    var v = converter
        .convertInt(int.parse(_formKey.currentState?.fields['amount']?.value));

    Content c = Content();
    c
      ..add(TextContent(
          's', '${_formKey.currentState?.fields['semester']?.value}'))
      ..add(TextContent(
          'c', '${_formKey.currentState?.fields['challan']?.value}'))
      ..add(TextContent('d', formattedDate))
      ..add(TextContent('r', '${_formKey.currentState?.fields['roll']?.value}'))
      ..add(TextContent('n', '${_formKey.currentState?.fields['name']?.value}'))
      ..add(TextContent(
          'fN', '${_formKey.currentState?.fields['amount']?.value}.00'))
      ..add(TextContent(
          't', '${_formKey.currentState?.fields['amount']?.value}.00'))
      ..add(TextContent('feeW', '${v.toTitleCase()} Rupees Only'));

    final d = await docx.generate(c);
    final of = File(
        "exports\\${formattedDashedDate}_${_formKey.currentState?.fields['roll']?.value}.docx");

    if (d != null) {
      await of.writeAsBytes(d);
    }

    // await Future.delayed(const Duration(seconds: 2));
    // Generate PDF document after success:
    // final PdfDocument document = PdfDocument(inputBytes: of.readAsBytesSync());
    // final PdfDocument document = PdfDocument(inputBytes: of.readAsBytesSync());

    // await of.writeAsBytes(await document.save());

    // File("exports\\${formattedDashedDate}_${_formKey.currentState?.fields['roll']?.value}.pdf")
    //     .writeAsBytes(await document.save());
    // document.dispose();
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
                              width: MediaQuery.of(context).size.width * 0.01,
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
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        name: 'semester',
                        decoration: InputDecoration(
                          labelText: 'Semester',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(1),
                          FormBuilderValidators.maxLength(1),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004,
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        name: 'challan',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Challan No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004,
                      ),
                      FormBuilderTextField(
                        name: 'roll',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Roll No.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004,
                      ),
                      FormBuilderTextField(
                        name: 'name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Name of Student',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004,
                      ),
                      FormBuilderTextField(
                        keyboardType: TextInputType.number,
                        name: 'amount',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                        decoration: InputDecoration(
                          labelText: 'Amount of Fee',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.004,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.save();
                          if (_formKey.currentState!.validate()) {
                            saveFileToDisk();
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
          ],
        ),
      ),
    );
  }
}

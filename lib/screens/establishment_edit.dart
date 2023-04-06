import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';


import '../constant/style_constant.dart';



class EditEstablishmentScreen extends StatefulWidget {
  final String estId;
  const EditEstablishmentScreen({super.key, required this.estId});

  @override
  State<EditEstablishmentScreen> createState() =>
      _EditEstablishmentScreenState();
}

class _EditEstablishmentScreenState extends State<EditEstablishmentScreen> {
  //Establishment Profile Controllers
  final estnameController = TextEditingController();
  final contpersonController = TextEditingController();
  final estaddController = TextEditingController();

  //Establishment Login Credential Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  //Other Variables
  final _formKey = GlobalKey<FormState>();

  void validateChanges() {
    if (_formKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Save changes...? ",
        text: null,
        confirmBtnText: "YES",
        cancelBtnText: "No",
        onConfirmBtnTap: () {
          Navigator.pop(context);
          updateChanges();
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  void updateChanges() async {
    EasyLoading.show(
      status: "Processing... ",
    );

    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.estId)
        .update(
      {
        "estname": estnameController.text,
        "contperson": contpersonController.text,
        "estadd": estaddController.text,
      },
    ).then(
      (value) {
        EasyLoading.showSuccess(
          "Establishment account has been updated successfully!",
        );
      },
    );
  }

  Future<void> editEstablishment() async {
    EasyLoading.show(status: "Loading... ");
    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.estId)
        .get()
        .then((snap) {
      estnameController.text = snap['estname'];
      contpersonController.text = snap['contperson'];
      estaddController.text = snap['estadd'];
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    super.initState();
    editEstablishment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: leadWidth,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Edit Establishment"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.025,
              horizontal: 12.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Edit your Establishment Profile: "),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your establishment name ";
                          }
                          return null;
                        },
                        controller: estnameController,
                        decoration: const InputDecoration(
                          labelText: 'Establishment Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your contact person's name ";
                          }
                          return null;
                        },
                        controller: contpersonController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Person Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your establishment address ";
                          }
                          return null;
                        },
                        controller: estaddController,
                        decoration: const InputDecoration(
                          labelText: 'Establishment Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: validateChanges,
                    style: ElevatedButton.styleFrom(
                      shape: roundedShape,
                    ),
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
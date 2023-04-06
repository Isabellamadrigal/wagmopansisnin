import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

import '../constant/style_constant.dart';


class EditUserScreen extends StatefulWidget {
  final String userId;
  const EditUserScreen({super.key, required this.userId});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  //User Profile Controllers
  final lnameController = TextEditingController();
  final mnameController = TextEditingController();
  final fnameController = TextEditingController();
  final addressController = TextEditingController();
  late DateTime bdate;

  //User Login Credential Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  //Other Variables
  final _formKey = GlobalKey<FormState>();
  dynamic currentState;
  // var obscurePass = true;
  // var obscureConfirm = true;

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
    // try {
    EasyLoading.show(
      status: "Processing... ",
    );

  

    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.userId)
        .update(
      {
        "fname": fnameController.text,
        "mname": mnameController.text,
        "lname": lnameController.text,
        "address": addressController.text,
        "bdate": bdate,
      },
    ).then(
      (value) {
        EasyLoading.showSuccess(
          "User account has been updated successfully!",
        );
      },
    );

   
  }

  Future<void> editUser() async {
    // final userAuth = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.userId)
        .get()
        .then((snap) {
      fnameController.text = snap['fname'];
      mnameController.text = snap['mname'];
      lnameController.text = snap['lname'];
      addressController.text = snap['address'];
      bdate = snap['bdate'].toDate();
      EasyLoading.dismiss();
    });

    // emailController.text = userAuth!.email!;
  }

  @override
  void initState() {
    super.initState();
    currentState = editUser();
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
        title: const Text("Edit User"),
      ),
      body: FutureBuilder(
          future: currentState,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if ((snapshot.connectionState == ConnectionState.done)) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight -
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
                              const Text("Edit your User Profile: "),
                              const SizedBox(height: 12),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "*Required. Please enter your first name ";
                                  }
                                  return null;
                                },
                                controller: fnameController,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: mnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Middle Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "*Required. Please enter your last name ";
                                  }
                                  return null;
                                },
                                controller: lnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "*Required. Please enter your address ";
                                  }
                                  return null;
                                },
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                                minLines: 1,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 12),
                              DateTimeFormField(
                                initialDate: bdate,
                                initialValue: bdate,
                                decoration: const InputDecoration(
                                  labelText: 'Birthdate',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.event_note),
                                ),
                                mode: DateTimeFieldPickerMode.date,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onDateSelected: (DateTime value) {
                                  bdate = value;
                                },
                              ),
                              // const SizedBox(height: 12),
                              // TextFormField(
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return "*Required. Please enter an email address. ";
                              //     }
                              //     if (!EmailValidator.validate(value)) {
                              //       return "Please enter a valid email address. ";
                              //     }
                              //     return null;
                              //   },
                              //   controller: emailController,
                              //   decoration: const InputDecoration(
                              //     labelText: 'Email Address',
                              //     border: OutlineInputBorder(),
                              //   ),
                              //
                              // ),
                              // const SizedBox(height: 12),
                              // TextFormField(
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return "*Required. Please enter your password. ";
                              //     }
                              //     if (value.length < 6) {
                              //       return "Password should be more than 6 characters";
                              //     }
                              //     return null;
                              //   },
                              //   obscureText: obscurePass,
                              //   controller: passwordController,
                              //   decoration: InputDecoration(
                              //     labelText: 'New Password',
                              //     border: const OutlineInputBorder(),
                              //     suffixIcon: IconButton(
                              //       onPressed: () => setState(
                              //         () => obscurePass = !obscurePass,
                              //       ),
                              //       icon: Icon(
                              //         obscurePass ? Icons.visibility : Icons.visibility_off,
                              //       ),
                              //     ),
                              //   ),
                              //
                              // ),
                              // const SizedBox(height: 12),
                              // TextFormField(
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return "*Required. Please enter your password. ";
                              //     }
                              //     if (value != passwordController.text) {
                              //       return "Passwords does not match";
                              //     }
                              //     return null;
                              //   },
                              //   obscureText: obscureConfirm,
                              //   controller: confirmpassController,
                              //   decoration: InputDecoration(
                              //     labelText: 'Confirm New Password',
                              //     border: const OutlineInputBorder(),
                              //     suffixIcon: IconButton(
                              //       onPressed: () => setState(
                              //         () => obscureConfirm = !obscureConfirm,
                              //       ),
                              //       icon: Icon(
                              //         obscureConfirm
                              //             ? Icons.visibility
                              //             : Icons.visibility_off,
                              //       ),
                              //     ),
                              //   ),
                              //
                              // ),
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
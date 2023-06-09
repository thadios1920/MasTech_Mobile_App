import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mastech/modules/Settings/settings_controller.dart';

import '../home/home_controller.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final SettingsController setttingsController = Get.put(SettingsController());
  final HomeController homeController = Get.put(HomeController());

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;

  bool _isChecked = false;

  Future _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _nomController =
        TextEditingController(text: setttingsController.user.value.nom);
    final _prenomController =
        TextEditingController(text: setttingsController.user.value.prenom);
    final _emailController =
        TextEditingController(text: setttingsController.user.value.email);
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _numTelController =
        TextEditingController(text: setttingsController.user.value.numTel);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(width: 2, color: Colors.grey),
                    ),
                    child: _image == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    // Validate email format using a regular expression
                    final emailRegex = RegExp(
                        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numTelController,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre téléphone';
                    }
                    // Validate phone number format using a regular expression
                    final phoneRegex = RegExp(r'^[0-9]+$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide (chiffres uniquement)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    const Text('Modifier le mot de passe'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_isChecked)
                  Column(
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true, // Set obscureText to true
                        decoration: const InputDecoration(
                          labelText: 'Nouveau mot de passe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nouveau mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true, // Set obscureText to true
                        decoration: const InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer votre mot de passe';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var data = {
                          'nom': _nomController.value.text,
                          'prenom': _prenomController.value.text,
                          'email': _emailController.value.text,
                          'numTel': _numTelController.value.text,
                          'newPassword': _newPasswordController.value.text,
                        };

                        if (_isChecked) {
                          // Modifier dans backend si vide envoyer image Url ancien
                          // await setttingsController.updateUserWithPassword(
                          //   _nomController.value.text,
                          //   _image!,
                          //   _prenomController.value.text,
                          //   _emailController.value.text,
                          //   _numTelController.value.text,
                          //   _newPasswordController.value.text,
                          // );
                        } else {
                          // Modifier dans backend si vide envoyer image Url ancien
                          await setttingsController.updateUser(
                            _nomController.value.text,
                            _image!,
                            _prenomController.value.text,
                            _emailController.value.text,
                            _numTelController.value.text,
                            '',
                          );
                        }

                        homeController.image.value = _image!;
                        homeController.nom.value = _nomController.value.text;
                        homeController.email.value =
                            _emailController.value.text;
                      }
                    },
                    child: const Text('Modifier'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

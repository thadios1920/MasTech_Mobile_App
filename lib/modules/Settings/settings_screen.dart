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
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numTelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;

  Future _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
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
                    labelText: 'Nom ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prenom ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer Prenom';
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
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Set obscureText to true
                  decoration: const InputDecoration(
                    labelText: 'Ancien mot de passe',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre ancien mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // modifier dans backend si vide envoyer image Url ancien
                        var data = {
                          'nom': _nomController.value.text,
                          'prenom': _prenomController.value.text,
                          'email': _emailController.value.text,
                          'numTel': _numTelController.value.text,
                          'newPassword': _newPasswordController.value.text,
                        };
                        // faire if il y a image sinon le meme lien de l'image

                        await setttingsController.updateUser(
                            _nomController.value.text,
                            _image!,
                            _prenomController.value.text,
                            _emailController.value.text,
                            _numTelController.value.text,
                            _newPasswordController.value.text);

                        homeController.image.value = _image!;
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

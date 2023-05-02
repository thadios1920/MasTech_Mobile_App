import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:pfe_mobile_app/services/auth_service.dart';
import 'package:pfe_mobile_app/services/helpers/shared_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/hex_color.dart';

import '../services/helpers/config.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> _globalFormKey = GlobalKey<FormState>();

  String? cin;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.indigo,
      body: ProgressHUD(
        child: Form(key: _globalFormKey, child: _loginUI(context)),
      ),
    ));
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/masLogo.jpg",
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
              child: Text(
                "Connexoin",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
            FormHelper.inputFieldWidget(
                context,
                prefixIcon: const Icon(Icons.person_outline_outlined),
                showPrefixIcon: true,
                "cin",
                "Cin", (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Cin ne peut pas etre vide";
              }
              return null;
            }, (onSavedVal) {
              cin = onSavedVal;
            },
                borderFocusColor: Colors.white,
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                borderRadius: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                  context,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  showPrefixIcon: true,
                  "password",
                  "Mot de passe", (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Mot de passe ne peut pas etre vide";
                }
                return null;
              }, (onSavedVal) {
                password = onSavedVal;
              },
                  borderFocusColor: Colors.white,
                  prefixIconColor: Colors.white,
                  borderColor: Colors.white,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.7),
                  borderRadius: 10,
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility))),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 25, top: 10),
                child: RichText(
                    text: TextSpan(
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14.0),
                        children: <TextSpan>[
                      TextSpan(
                          text: 'Mot de passe oublié ?',
                          style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("forget Pass");
                            })
                    ])),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton("Connexion", () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  AuthService.login(cin!, password!).then((res) => {
                        if (res)
                          {
                            // ici il faut verifier si chefProjet ou chefChantier
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/chefProjet', (route) => false),
                            print(SharedService.userDetails()),
                          }
                        else
                          {
                            FormHelper.showSimpleAlertDialog(
                                context,
                                Config.appName,
                                'Invalide cin ou mot de passe',
                                "OK", () {
                              Navigator.pop(context);
                            })
                          }
                      });
                }
              },
                  btnColor: HexColor("#283B71"),
                  borderColor: Colors.white,
                  txtColor: Colors.white,
                  borderRadius: 10),
            )
          ]),
    );
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}

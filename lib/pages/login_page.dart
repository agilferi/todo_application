import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_aplication/pages/home_page.dart';
import 'package:todo_aplication/handlers/shared_pref_handler.dart' as pref;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(
                size: 150.0,
                style: FlutterLogoStyle.stacked,
              ),
              const SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap: () {
                  _googleSignIn.signIn().then((value) {
                    setState(() {
                      pref.addEmail(value!.email);
                      pref.addName(value.displayName.toString());
                      pref.addPicture(value.photoUrl.toString());
                      pref.addIsLoggedIn(true);
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  }).catchError((e) {
                    pref.addEmail('user@gmail.com');
                    pref.addName('user');
                    pref.addPicture(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80');
                    pref.addIsLoggedIn(true);
                    debugPrint('Error Login = $e');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Login With Google',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // body: Container(
      //   child: _isLoggedIn
      //       ? Column(
      //           children: [
      //             Image.network(_userObj.photoUrl.toString()),
      //             Text(_userObj.displayName.toString()),
      //             Text(_userObj.email),
      //             TextButton(
      //                 onPressed: () {
      //                   _googleSignIn.signOut().then((value) {
      //                     setState(() {
      //                       _isLoggedIn = false;
      //                     });
      //                   }).catchError((e) {});
      //                 },
      //                 child: Text("Logout"))
      //           ],
      //         )
      //       : Center(
      //           child: ElevatedButton(
      //             child: Text("Login with Google"),
      //             onPressed: () {
      //               _googleSignIn.signIn().then((userData) {
      //                 setState(() {
      //                   _isLoggedIn = true;
      //                   _userObj = userData!;
      //                 });
      //               }).catchError((e) {
      //                 print(e);
      //               });
      //             },
      //           ),
      //         ),
      // ),
    );
  }
}

import 'package:flutter/material.dart';

import 'songs_gigs_main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return orientation == Orientation.portrait
        //===================
        //===================
        //Portrait layout
        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 35,
              child: Container(
                color: const Color.fromRGBO(57, 62, 70, 1.0),
                child: Image.asset(
                  'assets/images/logo-transparent.png',
                ),
              ),
            ),
            getLoginForm(context),
          ])

        //===================
        //===================
        //Landscape layout
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 45,
                child: Container(
                  color: const Color.fromRGBO(57, 62, 70, 1.0),
                  child: Image.asset(
                    'assets/images/logo-transparent.png',
                  ),
                ),
              ),
              getLoginForm(context),
            ],
          );
  }

  Expanded getLoginForm(BuildContext context) {
    return Expanded(
        flex: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add some spacing between the fields
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: UnderlineInputBorder(),
                ),
                obscureText:
                    true, // This will obscure the text for password field
              ),
            ),
            const SizedBox(height: 20.0), // Add some spacing before the button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SongsGigsMain()),
                );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('Forgot Password?'),
            ),
            TextButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('Create Account'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Handle Apple SSO
              },
              icon: const Icon(Icons.apple, size: 24.0),
              label: const Text('Sign in with Apple'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            const SizedBox(height: 20.0), // Add some spacing between the buttons

            // Google SSO Button
            ElevatedButton.icon(
              onPressed: () {
                // Handle Google SSO
              },
              icon: Image.asset('assets/images/google_logo.png', height: 24.0),
              label: const Text('Sign in with Google'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
            const SizedBox(height: 20.0), // Add some spacing between the buttons

            // Facebook SSO Button
            ElevatedButton.icon(
              onPressed: () {
                // Handle Facebook SSO
              },
              icon: const Icon(Icons.facebook, size: 24.0),
              label: const Text('Sign in with Facebook'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF3b5998)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ));
  }
}

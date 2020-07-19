import 'package:apptware/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

initializeUser(Auth auth) async {
  print('here');
  try {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.email);
    if (firebaseUser != null) {
      auth.setUser(firebaseUser);
    }
  } catch (e) {
    print(e.toString());
  }
}

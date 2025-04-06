import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_button.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_text_field.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? tooglepages;
  const LoginPage({super.key, required this.tooglepages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();
  final pwcontroller = TextEditingController();
  void Login() {
    //em pass
    final String email = emailcontroller.text;
    final String pw = pwcontroller.text;
    //
    final authCubit = context.read<AuthCubits>();
    if (email.isNotEmpty && pw.isNotEmpty) {
      // lofin
      authCubit.login(email, pw);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter uesreanme , or pass')));
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    pwcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.lock_open_rounded,
                //   size: 80,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
                FaIcon(
                  FontAwesomeIcons.instagram, // 📸 Insta icon
                  size: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Instagram color vibe
                ),
                SizedBox(
                  height: 50,
                ),
                //welc
                Text(
                  "Welcome back , youve been missed!",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 25,
                ),
                //ema
                MyTextField(
                  controller: emailcontroller,
                  hinText: 'Email',
                  obscureText: false,
                ),
                SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: pwcontroller,
                  hinText: 'password',
                  obscureText: true,
                ),
                SizedBox(
                  height: 25,
                ),
                MyButton(onTap: Login, text: 'login'),

                SizedBox(
                  height: 50,
                ),
                //not a mem
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member ,",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.tooglepages,
                      child: Text(
                        " Register now! ,",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

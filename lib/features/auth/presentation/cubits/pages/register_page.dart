import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_button.dart';
import 'package:my_ui/features/auth/presentation/cubits/components/my_text_field.dart';
import 'package:my_ui/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? tooglepages;
  const RegisterPage({super.key, required this.tooglepages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final pwcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final confpwcontroller = TextEditingController();
  void register() {
    final String name = namecontroller.text;
    final String email = emailcontroller.text;
    final String pw = pwcontroller.text;
    final String confrimpw = confpwcontroller.text;
    final authCubit = context.read<AuthCubits>();
    //not empy
    if (email.isNotEmpty &&
        name.isNotEmpty &&
        pw.isNotEmpty &&
        confrimpw.isNotEmpty) {
      if (pw == confrimpw) {
        authCubit.register(name, email, pw);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("pass dosnot match")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("please complete all fiels ")));
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    pwcontroller.dispose();
    confpwcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.instagram, // 📸 Insta icon
                    size: 80,
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Instagram color vibe
                  ),
                  // Icon(
                  //   Icons.lock_open_rounded,
                  //   size: 80,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  SizedBox(
                    height: 50,
                  ),
                  //welc
                  Text(
                    "Lets craete an account for you ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  //ema
                  MyTextField(
                    controller: namecontroller,
                    hinText: 'Name',
                    obscureText: false,
                  ),
                  SizedBox(
                    height: 10,
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
                    hinText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    controller: confpwcontroller,
                    hinText: 'Confrom Password',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyButton(onTap: register, text: 'Register'),

                  SizedBox(
                    height: 30,
                  ),
                  //not a mem
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a memeber  ,  ",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      GestureDetector(
                        onTap: widget.tooglepages,
                        child: Text(
                          "Login now!",
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
      ),
    );
  }
}

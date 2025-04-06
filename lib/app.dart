import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/data/firebase_auth_repo.dart';
import 'package:my_ui/features/auth/home/presenattion/pages/home_page.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_states.dart';
import 'package:my_ui/features/auth/presentation/cubits/pages/auth_page.dart';
import 'package:my_ui/features/auth/profiel/data/firebase_profile_repo.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/post/data/firebase_post_repo.dart';
import 'package:my_ui/features/post/presentation/cubits/post_cubit.dart';
import 'package:my_ui/features/search/data/firebase_search_repo.dart';
import 'package:my_ui/features/search/presentation/cubits/search_cubit.dart';
import 'package:my_ui/features/storage/domain/data/firebase_storage_repo.dart';
import 'package:my_ui/features/storage/domain/storage_repo.dart';
import 'package:my_ui/splash/presentation/splash_screen.dart';
import 'package:my_ui/themes/light_mode.dart';
import 'package:my_ui/themes/theme_cubit.dart';

/*
=firebase 
auth , profi, post , search , tehme . 

unauth+>Yth 
auth +>home



*/

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authRepo = FirebaseAuthRepo();

  //profil
  final profileReop = FirebaseProfileRepo();

  final storageRepo = SupabaseStorageRepo();

  // FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();

  //searc repo
  final firebaseSearchRepo = FirebaseSearchRepo();

  bool isSplashDone = false;

  @override
  void initState() {
    super.initState();
    // Simulate splash delay
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isSplashDone = true;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //auth
          BlocProvider<AuthCubits>(
              create: (context) =>
                  AuthCubits(authRepos: authRepo)..checkAuth()),
          //profile
          BlocProvider<ProfielCubit>(
              create: (context) => ProfielCubit(
                  profileRepo: profileReop, storageRepo: storageRepo)),
          //post
          BlocProvider<PostCubit>(
              create: (context) => PostCubit(
                  postRepo: firebasePostRepo, storageRepo: storageRepo)),

          //search
          BlocProvider<SearchCubit>(
              create: (context) => SearchCubit(searchRepo: firebaseSearchRepo)),
          // theme
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        ],
        //blocbuilder
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, currentTheme) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: currentTheme,

            //check auth state
            home: BlocConsumer<AuthCubits, AuthStates>(
              builder: (context, authState) {
                print(authState);

                //
                if (!isSplashDone) {
                  return const SplashScreen(); // ⬅️ show splash first
                }
                //unauth
                if (authState is Unauthenticated) {
                  return const AuthPage();
                }
                //auth
                if (authState is Authenticated) {
                  return const HomePage();
                }
                //loading
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              listener: (context, state) {
                if (state is Autherrors) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
            ),
          ),
        ));
  }
}

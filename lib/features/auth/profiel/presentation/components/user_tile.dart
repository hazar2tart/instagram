import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ui/features/auth/profiel/domain/entitites/profiel_user.dart';
import 'package:my_ui/features/auth/profiel/presentation/cubits/profiel_cubit.dart';
import 'package:my_ui/features/auth/profiel/presentation/pages/profiel_page.dart';

class UserTile extends StatefulWidget {
  final ProfielUser user;
  const UserTile({super.key, required this.user});

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  late ProfielUser user;

  @override
  void initState() {
    super.initState();
    user = widget.user; // Initial user data from the widget
  }

  void _updateUserProfile() {
    // Trigger state update (e.g., by calling a Cubit method)
    context.read<ProfielCubit>().fetchUserProfiel(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        user.name,
        style: TextStyle(color: Colors.red),
      ),
      subtitle: Text(user.email),
      subtitleTextStyle:
          TextStyle(color: Theme.of(context).colorScheme.primary),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: () {
        _updateUserProfile(); // Update user profile before navigation

        // Push the profile page and immediately refresh the data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<ProfielCubit>(),
              child: ProfielPage(uid: user.uid),
            ),
          ),
        );
      },
    );
  }
}

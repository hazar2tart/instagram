import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_ui/features/auth/home/presenattion/pages/components/my_drawer_tile.dart';
import 'package:my_ui/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:my_ui/features/auth/profiel/presentation/pages/profiel_page.dart';
import 'package:my_ui/features/search/presentation/pages/search_page.dart';
import 'package:my_ui/features/settings/pages/settings_pages.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: FaIcon(
                  FontAwesomeIcons.instagram, // 📸 Insta icon
                  size: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Instagram color vibe
                ),
                // Icon(
                //   Icons.person,
                //   size: 80,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              MyDrawerTile(
                title: "HOME",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),
              // Profile Tile
              MyDrawerTile(
                title: "PROFIEL PICTURE",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop();
                  // Get current user and update the UI
                  final user = context.read<AuthCubits>().currentUser;
                  String? uid = user!.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfielPage(
                        uid: uid,
                      ),
                    ),
                  );
                },
              ),
              // Search Tile
              MyDrawerTile(
                title: "SEARCH",
                icon: Icons.search,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              // Settings Tile
              MyDrawerTile(
                title: "SETTINGS",
                icon: Icons.settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPages()),
                  );
                },
              ),
              // Logout Tile
              Spacer(),
              MyDrawerTile(
                title: "LOGOUT",
                icon: Icons.login,
                onTap: () {
                  // Log out the user
                  context.read<AuthCubits>().logout();
                  setState(
                      () {}); // Trigger state update (e.g., after logging out)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

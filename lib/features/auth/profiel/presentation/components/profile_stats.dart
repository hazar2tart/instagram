/*


profil stats

this be displayed on all profile pages
post s
followes
folloowing
*/

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats(
      {super.key,
      required this.followerCount,
      required this.followingCount,
      required this.postCount,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);
    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    print("folowe count : ${followerCount.toString}");
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //pots
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCount.toString(),
                  style: textStyleForText,
                ),
                Text(
                  "Posts",
                  style: textStyleForText,
                )
              ],
            ),
          ),
          //folle
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: textStyleForText,
                ),
                Text("Followers", style: textStyleForText)
              ],
            ),
          ),
          //follw
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingCount.toString(),
                  style: textStyleForText,
                ),
                Text("Following", style: textStyleForText)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

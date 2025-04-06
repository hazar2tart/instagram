import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App Logo with Glow Effect
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            //  color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.white.withValues(alpha: 0.4),
            //     blurRadius: 20,
            //     spreadRadius: 5,
            //   ),
            // ],
          ),
          child: FaIcon(
            FontAwesomeIcons.instagram, // 📸 Insta icon
            size: 80,
            color: Colors.purple, // Instagram color vibe
          ),

          //  const Icon(
          //   Icons.insta,
          //   size: 80,
          //   color: Colors.white,
          // ),
        ),
        const SizedBox(height: 20),
        // App Name with Gradient Text
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                const Color.fromARGB(255, 88, 144, 189),
                const Color.fromARGB(255, 132, 99, 138),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: const Text(
            'Cinsta',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Tagline with Fade Animation
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2),
          child: const Text(
            '',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

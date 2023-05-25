import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: const Text(
            '''About Us : 
      
      We are a team of passionate music lovers who have come together to create a better music listening experience for you. Our app is designed to make it easy for you to discover new music, create personalized playlists, and enjoy your favorite tracks anytime, anywhere.
      
      We believe in the power of music to bring people together, and we strive to create a welcoming and inclusive community for music fans of all kinds. We are constantly working to improve the app and add new features to enhance your listening experience.
      
      Thank you for choosing 'Blaze Player' as your go-to music player. We hope you enjoy using it as much as we enjoyed creating it. If you have any feedback or suggestions, we would love to hear from you. Contact us at sirajmuhammed718@gmail.com.
      
      ''',
            style: TextStyle(
                fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

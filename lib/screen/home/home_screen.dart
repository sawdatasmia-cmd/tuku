import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../services/user_service.dart';

import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isOpeningChat = false;

  Future<void> _openChat() async {
    setState(() {
      _isOpeningChat = true;
    });

    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('NO_CURRENT_USER');
      }

      final users = await _userService.getAllUsers();

      final otherUsers = users
          .where(
            (user) => user.id != currentUser.uid,
          )
          .toList();

      if (!mounted) {
        return;
      }

      if (otherUsers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No other Tuku user is available yet.',
            ),
          ),
        );

        return;
      }

      final TukuUser otherUser = otherUsers.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            otherUser: otherUser,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open the conversation.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuku!!'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'You Are HOME!Welcome to Tuku!!',
              style: TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
                  _isOpeningChat ? null : _openChat,
              child: _isOpeningChat
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Let\'s Chat'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProfileScreen(),
                  ),
                );
              },
              child: const Text('Profile'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SettingsScreen(),
                  ),
                );
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
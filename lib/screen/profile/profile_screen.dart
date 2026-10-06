import 'package:flutter/material.dart';

import 'package:tuku/model/user_model.dart';
import 'package:tuku/services/auth_service.dart';
import 'package:tuku/services/user_sevice.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  TukuUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final firebaseUser = _authService.currentUser;

    if (firebaseUser == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final user = await _userService.getUserProfile(firebaseUser.uid);

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been logged out.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not log out. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8EE),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF410200),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF410200),
              ),
            )
          : _user == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_off_outlined,
                          size: 56,
                          color: Color(0xFF72554D),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Could not load your profile.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF410200),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _loadProfile,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1D8CC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: Color(0xFF410200),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _user!.tasmiaGivenName,
                        style: const TextStyle(
                          color: Color(0xFF410200),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '@${_user!.username}',
                        style: const TextStyle(
                          color: Color(0xFF72554D),
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account',
                              style: TextStyle(
                                color: Color(0xFF410200),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Color(0xFF72554D),
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              _user!.email,
                              style: const TextStyle(
                                color: Color(0xFF2B211D),
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Tasmia Given Name',
                              style: TextStyle(
                                color: Color(0xFF72554D),
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              _user!.tasmiaGivenName,
                              style: const TextStyle(
                                color: Color(0xFF2B211D),
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 18),

                            const Text(
                              'Tuku Username',
                              style: TextStyle(
                                color: Color(0xFF72554D),
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '@${_user!.username}',
                              style: const TextStyle(
                                color: Color(0xFF2B211D),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _logout,
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF410200),
                            side: const BorderSide(
                              color: Color(0xFF410200),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
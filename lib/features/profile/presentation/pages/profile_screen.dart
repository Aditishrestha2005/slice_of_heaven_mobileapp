import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/api/api_endpoints.dart';
import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/auth/presentation/pages/loginpage_screen.dart';
import 'package:slice_of_heaven/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:slice_of_heaven/features/profile/presentation/pages/update_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String fullName = "";
  String email = "";
  String phone = "";
  File? profileImage;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final session = ref.read(userSessionServiceProvider);

    final name = session.getCurrentUserFullName();
    final mail = session.getCurrentUserEmail();
    final ph = session.getCurrentUserPhoneNumber();
    final profilePath = session.getCurrentUserProfilePicture();

    File? imageFile;
    String? url;

    if (profilePath != null && profilePath.isNotEmpty) {
      if (profilePath.startsWith('http')) {
        url = profilePath;
      } else {
        final file = File(profilePath);
        if (file.existsSync()) {
          imageFile = file;
        }
      }
    }

    if (!mounted) return;

    setState(() {
      fullName = name ?? "";
      email = mail ?? "";
      phone = ph ?? "";
      profileImage = imageFile;
      profileImageUrl = url;
    });
  }

  String _fullImageUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = ApiEndpoints.baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UpdateProfileScreen()),
    );
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 255, 163, 97),
                    Color.fromARGB(255, 252, 186, 93),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : profileImageUrl != null
                                ? NetworkImage(_fullImageUrl(profileImageUrl!))
                                : null,
                        child: profileImage == null && profileImageUrl == null
                            ? const Icon(Icons.person,
                                size: 55, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _openEditProfile,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.edit,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 16, 15, 15)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(color: Color.fromARGB(179, 6, 6, 6)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// INFO CARDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _profileTile(Icons.person, "Full Name", fullName),
                  _profileTile(Icons.email, "Email", email),
                  _profileTile(Icons.phone, "Phone", phone),
                  _profileTile(Icons.lock, "Password", "********"),
                ],
              ),
            ),

            const Spacer(),


            /// LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 7, 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                            'Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref
                          .read(authViewModelProvider.notifier)
                          .logout();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const LoginpageScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text("Logout"),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          Text(value,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
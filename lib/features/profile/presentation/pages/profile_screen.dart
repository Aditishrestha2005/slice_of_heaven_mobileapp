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
    await _loadUserData(); // refresh after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// PROFILE IMAGE WITH EDIT ICON (Camera used in Update Profile to capture photo)
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : profileImageUrl != null
                          ? NetworkImage(_fullImageUrl(profileImageUrl!))
                          : null,
                  child: profileImage == null && profileImageUrl == null
                      ? const Icon(Icons.person, size: 55, color: Colors.white)
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
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _profileTile("Full Name", fullName),
            _profileTile("Email", email),
            _profileTile("Phone", phone),
            _profileTile("Password", "********"),
            const Spacer(),

            /// EDIT PROFILE BUTTON (optional but kept)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _openEditProfile,
                child: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(authViewModelProvider.notifier).logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginpageScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:slice_of_heaven/core/services/storage/user_session_service.dart';
import 'package:slice_of_heaven/features/profile/presentation/state/profile_state.dart';
import 'package:slice_of_heaven/features/profile/presentation/view_model/profile_view_model.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedXFile;
  bool _pickedNewImage = false; // ✅ track if user picked a new image
  bool _isLoading = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    final session = ref.read(userSessionServiceProvider);

    _nameController = TextEditingController(
      text: session.getCurrentUserFullName() ?? '',
    );

    _emailController = TextEditingController(
      text: session.getCurrentUserEmail() ?? '',
    );

    _phoneController = TextEditingController(
      text: session.getCurrentUserPhoneNumber() ?? '',
    );

    // Load existing saved image path (permanent) if available
    final existingPath = session.getCurrentUserProfilePicture();
    if (existingPath != null && existingPath.isNotEmpty) {
      final f = File(existingPath);
      if (f.existsSync()) {
        _pickedXFile = XFile(existingPath);
        _pickedNewImage = false;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage(ImageSource source) async {
    final PermissionStatus permission = source == ImageSource.camera
        ? await Permission.camera.request()
        : (Platform.isIOS
            ? await Permission.photos.request()
            : await Permission.storage.request());

    if (!permission.isGranted) return;

    final XFile? image =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (image != null) {
      setState(() {
        _pickedXFile = image; // cache path for now
        _pickedNewImage = true;
      });
    }
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Save image bytes to permanent app directory
  Future<String?> _persistProfileImage({
    required String userId,
    required XFile? picked,
  }) async {
    if (picked == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);

    final ext = p.extension(picked.path);
    final fileName = 'profile_$userId${ext.isEmpty ? ".jpg" : ext}';
    final newPath = p.join(dir.path, fileName);

    final bytes = await picked.readAsBytes();
    final outFile = File(newPath);
    await outFile.writeAsBytes(bytes, flush: true);

    return outFile.path;
  }

  // ================= SAVE CHANGES =================
  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    try {
      final session = ref.read(userSessionServiceProvider);
      final userId = session.getCurrentUserId();

      if (userId == null || userId.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found. Please log in again.")),
        );
        return;
      }

      // ✅ Keep existing image path if user didn't pick new image
      final existingPath = session.getCurrentUserProfilePicture();

      String? finalImagePath = existingPath;

      // ✅ Persist only if user selected a NEW image
      if (_pickedNewImage && _pickedXFile != null) {
        finalImagePath =
            await _persistProfileImage(userId: userId, picked: _pickedXFile);
      }

      // ✅ Send to backend ONLY if new image picked and finalImagePath exists
      File? fileForBackend;
      if (_pickedNewImage && finalImagePath != null && finalImagePath.isNotEmpty) {
        final f = File(finalImagePath);
        if (f.existsSync()) {
          fileForBackend = f;
        }
      }

      // ✅ update hive/session + backend via viewmodel
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            userId: userId,
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            profilePicturePath: finalImagePath,
            profilePictureFile: fileForBackend,
          );

      if (!mounted) return;

      final state = ref.read(profileViewModelProvider);

      if (state.status == ProfileStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? "Update failed")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  ImageProvider? _getProfileImage() {
    if (_pickedXFile == null) return null;

    final file = File(_pickedXFile!.path);
    if (file.existsSync()) return FileImage(file);

    return null;
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _getProfileImage(),
                  child: _getProfileImage() == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showPickOptions,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

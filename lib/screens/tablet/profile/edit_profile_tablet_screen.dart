import 'package:dister/controllers/firebase/other_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:dister/generated/l10n.dart';
import 'package:dister/widgets/sidebar_tablet.dart';
import 'package:dister/widgets/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dister/screens/tablet/others/home_tablet_screen.dart';

class EditProfileTabletScreen extends StatefulWidget {
  final String userId;
  const EditProfileTabletScreen({super.key, required this.userId});

  @override
  State<EditProfileTabletScreen> createState() =>
      _EditProfileTabletScreenState();
}

class _EditProfileTabletScreenState extends State<EditProfileTabletScreen> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _userPhoto;
  File? _selectedImage;
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists && mounted) {
        setState(() {
          _descController.text = userDoc['desc'] ?? '';
          _usernameController.text = userDoc['username'] ?? '';
          _ageController.text = userDoc['age']?.toString() ?? '';
          _phoneController.text = userDoc['phoneNumber'] ?? '';
          _userPhoto = userDoc['photo'];
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorGeneric(e.toString()))),
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'desc': _descController.text.trim(),
        'username': _usernameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()),
        'phoneNumber': _phoneController.text.trim(),
      });

      if (_selectedImage != null) {
        String downloadUrl = await _firebaseServices.uploadProfilePicture(
          widget.userId,
          _selectedImage!,
        );

        await _firebaseServices.updateUserPhoto(widget.userId, downloadUrl);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).profileUpdated)),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorGeneric(e.toString()))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarTablet(
              selectedIndex: 4,
              onTap: (index) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeTabletScreen(initialIndex: index),
                  ),
                  (route) => false,
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              S.of(context).editProfile,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      _selectedImage != null
                                          ? FileImage(_selectedImage!)
                                          : (_userPhoto != null &&
                                                      !_userPhoto!
                                                          .startsWith('assets/')
                                                  ? NetworkImage(_userPhoto!)
                                                  : const AssetImage(
                                                      'assets/images/default.png'))
                                              as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _usernameController,
                          isPassword: false,
                          hintText: S.of(context).hintUser,
                          label: S.of(context).userLabel,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _ageController,
                          isPassword: false,
                          hintText: S.of(context).hintAge,
                          label: S.of(context).ageLabel,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          isPassword: false,
                          hintText: S.of(context).hintPhone,
                          label: S.of(context).phoneLabel,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _descController,
                          isPassword: false,
                          hintText: S.of(context).description,
                          label: S.of(context).description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator())
                            : Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  onPressed: _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 36, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).saveChanges,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

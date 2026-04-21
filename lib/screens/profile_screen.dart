import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/constants/app_colors.dart';
import 'package:recipe_app/repo/user_repository.dart';
import 'package:recipe_app/screens/check_screen.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';
import 'package:recipe_app/widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? auth = FirebaseAuth.instance.currentUser;
  final UserRepository _userRepository = UserRepository();
  String? userName;
  String? email;
  String? photoUrl;
  String? phoneNumber;
  bool _loading = false;
  bool _showSavePhone = false;
  bool _showSaveName = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _hydrateFromAuth();
    _fetchProfile();
    super.initState();
  }

  void _hydrateFromAuth() {
    userName = auth?.displayName;
    email = auth?.email;
    photoUrl = auth?.photoURL;
    phoneNumber = auth?.phoneNumber;

    // Firebase does not expose the actual password; keep the field empty for edits.
    _nameController.text = userName ?? "";
    _emailController.text = email ?? "";
    _mobileController.text = phoneNumber ?? "";
    _passwordController.text = "";
  }

  Future<void> _fetchProfile() async {
    final uid = auth?.uid;
    if (uid == null) return;
    setState(() => _loading = true);
    try {
      final user = await _userRepository.getUser(uid);
      if (user != null) {
        setState(() {
          userName = user.name;
          _nameController.text = user.name;
          _emailController.text = user.email;
          _mobileController.text = user.phone;
          phoneNumber = user.phone;
          _showSaveName = false;
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveName() async {
    final uid = auth?.uid;
    final name = _nameController.text.trim();
    if (uid == null || name.isEmpty) return;
    setState(() => _loading = true);
    try {
      await _userRepository.updateName(uid, name);
      await auth?.updateDisplayName(name);
      setState(() {
        userName = name;
        _showSaveName = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _savePhone() async {
    final uid = auth?.uid;
    final phone = _mobileController.text.trim();
    if (uid == null || phone.isEmpty) return;
    setState(() => _loading = true);
    try {
      await _userRepository.updatePhone(uid, phone);
      setState(() => phoneNumber = phone);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mobile number saved')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            CircleAvatar(
              radius: 50.r,
              backgroundImage: NetworkImage(
                photoUrl != null
                    ? "$photoUrl"
                    : "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png",
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit, color: AppColors.primaryColor, size: 16),
                SizedBox(width: 5),
                Text(
                  'Edit Profile Photo',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  CustomTextField(
                    hintText: userName ?? "Enter Your Name",
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    onTap: () => setState(() => _showSaveName = true),
                    onChanged: (_) => setState(() => _showSaveName = true),
                  ),
                  if (_showSaveName) ...[
                    SizedBox(height: 10.h),
                    PrimaryButton(
                      onPressed: _loading ? null : _saveName,
                      text: _loading ? "Saving..." : "Save Name",
                      textColor: AppColors.whiteColor,
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ],
                  SizedBox(height: 20.h),
                  CustomTextField(
                    hintText: email ?? "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    readOnly: true,
                  ),
                  SizedBox(height: 20.h),
                CustomTextField(
                  hintText: "Mobile Number",
                  keyboardType: TextInputType.phone,
                  controller: _mobileController,
                  onTap: () => setState(() => _showSavePhone = true),
                  onChanged: (_) => setState(() => _showSavePhone = true),
                ),
                if (_showSavePhone) ...[
                  SizedBox(height: 10.h),
                  PrimaryButton(
                    onPressed: _loading ? null : _savePhone,
                    text: _loading ? "Saving..." : "Save Mobile",
                    textColor: AppColors.whiteColor,
                    backgroundColor: AppColors.primaryColor,
                  ),
                ],
                  SizedBox(height: 20.h),
                  CustomTextField(
                    readOnly: true,
                    hintText: "********",
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 150.h),
                  PrimaryButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckScreen(),
                        ),
                      );
                    },
                    text: "Log Out",
                    textColor: AppColors.whiteColor,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

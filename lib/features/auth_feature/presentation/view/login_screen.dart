// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:money/core/colors/app_color.dart';
// import 'package:money/features/auth_feature/presentation/auth_provider.dart';
// import 'package:money/features/home/presentation/view/home_tab.dart';
// import 'package:provider/provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isLogin = true;
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     try {
//       if (_isLogin) {
//         final response = await authProvider.login(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//         );
//         if (!response.success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(response.message ?? 'Login failed')),
//           );
//         }
//       } else {
//         final response = await authProvider.register(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//           _nameController.text.trim(),
//           _phoneController.text.trim(),
//         );
//         if (!response.success && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(response.message ?? 'Registration failed')),
//           );
//         }
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.primaryColor,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     _isLogin ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.cairo(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: AppColor.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _isLogin
//                         ? 'مرحباً بك مجدداً في تطبيق المصاريف'
//                         : 'ابدأ بتنظيم مصاريفك اليوم',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.cairo(
//                       fontSize: 16,
//                       color: AppColor.gray,
//                     ),
//                   ),
//                   const SizedBox(height: 48),
//                   if (!_isLogin) ...[
//                     _buildTextField(
//                       controller: _nameController,
//                       label: 'الاسم الكامل',
//                       icon: Icons.person_outline,
//                       validator: (value) =>
//                           value!.isEmpty ? 'يرجى إدخال الاسم' : null,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextField(
//                       controller: _phoneController,
//                       label: 'رقم الهاتف',
//                       icon: Icons.phone_outlined,
//                       keyboardType: TextInputType.phone,
//                       validator: (value) =>
//                           value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   _buildTextField(
//                     controller: _emailController,
//                     label: 'البريد الإلكتروني',
//                     icon: Icons.email_outlined,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) =>
//                         value!.contains('@') ? null : 'بريد إلكتروني غير صالح',
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     controller: _passwordController,
//                     label: 'كلمة المرور',
//                     icon: Icons.lock_outline,
//                     isPassword: true,
//                     validator: (value) => value!.length < 6
//                         ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
//                         : null,
//                   ),
//                   const SizedBox(height: 32),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (!_isLoading) {
//                         _submit;
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => HomeTab()),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: AppColor.blueStart,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                             _isLogin ? 'دخول' : 'تسجيل',
//                             style: GoogleFonts.cairo(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: () => setState(() => _isLogin = !_isLogin),
//                     child: Text(
//                       _isLogin
//                           ? 'ليس لديك حساب؟ سجل الآن'
//                           : 'لديك حساب بالفعل؟ سجل دخولك',
//                       style: GoogleFonts.cairo(color: AppColor.mediumSlateBlue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword,
//       keyboardType: keyboardType,
//       validator: validator,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: AppColor.gray),
//         prefixIcon: Icon(icon, color: AppColor.gray),
//         filled: true,
//         fillColor: AppColor.bottomNavBarBackGround,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColor.borderGray),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: AppColor.blueStart),
//         ),
//       ),
//     );
//   }
// }

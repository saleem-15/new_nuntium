// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:new_nuntium/core/constants/app_assets.dart'; // تأكد من أيقوناتك
// import 'package:new_nuntium/core/theme/app_colors.dart';
// import 'package:new_nuntium/features/auth/presentation/controller/create_new_password_controller.dart';

// class CreateNewPasswordView extends GetView<CreateNewPasswordController> {
//   const CreateNewPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//         child: Form(
//           key: controller.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // زر الرجوع
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: SvgPicture.asset(AppIcons.back, width: 24.w),
//               ),
//               SizedBox(height: 32.h),

//               // العنوان
//               Text(
//                 "Create New Password 🔒",
//                 style: TextStyle(
//                   fontSize: 24.sp,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.blackPrimary,
//                 ),
//               ),
//               SizedBox(height: 8.h),

//               // الوصف
//               Text(
//                 "You can create a new password, please dont forget it too.",
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: AppColors.greyPrimary,
//                   height: 1.5,
//                 ),
//               ),
//               SizedBox(height: 32.h),

//               // حقل كلمة المرور الجديدة
//               Obx(
//                 () => _buildPasswordField(
//                   controller: controller.newPasswordController,
//                   hintText: "New Password",
//                   isObscure: controller.isNewPasswordHidden.value,
//                   onToggleVisibility: controller.toggleNewPasswordVisibility,
//                   validator: (value) {
//                     if (value == null || value.length < 6)
//                       return "Password too short";
//                     return null;
//                   },
//                 ),
//               ),

//               SizedBox(height: 16.h),

//               // حقل تكرار كلمة المرور
//               Obx(
//                 () => _buildPasswordField(
//                   controller: controller.repeatPasswordController,
//                   hintText: "Repeat New Password",
//                   isObscure: controller.isRepeatPasswordHidden.value,
//                   onToggleVisibility: controller.toggleRepeatPasswordVisibility,
//                   validator: (value) {
//                     if (value != controller.newPasswordController.text) {
//                       return "Passwords do not match";
//                     }
//                     return null;
//                   },
//                 ),
//               ),

//               SizedBox(height: 50.h), // مسافة قبل الزر
//               // زر التأكيد
//               ElevatedButton(
//                 onPressed: controller.changePassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.purplePrimary,
//                   minimumSize: Size(double.infinity, 56.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   "Confirm",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget مساعد لحقول الباسوورد لتقليل تكرار الكود
//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String hintText,
//     required bool isObscure,
//     required VoidCallback onToggleVisibility,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isObscure,
//       validator: validator,
//       style: TextStyle(fontSize: 16.sp, color: AppColors.blackPrimary),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: AppColors.greyPrimary),
//         filled: true,
//         fillColor: const Color(
//           0xFFF3F4F6,
//         ), // لون الخلفية الرمادي الفاتح حسب التصميم
//         prefixIcon: Padding(
//           padding: EdgeInsets.all(12.w),
//           child: Icon(Icons.lock_outline, color: AppColors.greyPrimary),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             isObscure
//                 ? Icons.visibility_off_outlined
//                 : Icons.visibility_outlined,
//             color: AppColors.greyPrimary,
//           ),
//           onPressed: onToggleVisibility,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: BorderSide.none, // بدون حدود
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(
//             color: AppColors.purplePrimary,
//             width: 1,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.r),
//           borderSide: const BorderSide(color: Colors.red, width: 1),
//         ),
//       ),
//     );
//   }
// }

import 'package:daily_expense_tracker_app/features/profile/view/widgets/date_of_birth_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_service/user_service.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../blocs/profile_bloc/profile_cubit.dart';
import 'widgets.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late User user;

  @override
  void initState() {
    user = context.read<ProfileCubit>().currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ProfileCubit>().formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ProfileImage(user: user),
          const SizedBox(height: 20),
          Text(
            user.fullName,
            style: AppTextStyle.title.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            maxLines: 1,
            fontSize: 16,
            hintText: 'VD: Tung Nguyen',
            controller: context.read<ProfileCubit>().fullNameController,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w400,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(FontAwesomeIcons.userLarge, size: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: const BorderSide(width: 1.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.outline,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.error,
                width: 1.2,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Tên không thể để trống';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            maxLines: 1,
            fontSize: 16,
            hintText: 'VD: 0816 904 167',
            controller: context.read<ProfileCubit>().phoneNumberController,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w400,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(FontAwesomeIcons.phone, size: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: const BorderSide(width: 1.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.outline,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(
                color: context.colorScheme.error,
                width: 1.2,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              final phoneRegExp = RegExp(r'^(0\d{3}\s\d{3}\s\d{3})$');
              if (!phoneRegExp.hasMatch(value)) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          DateOfBirthPicker(
            onYearChanged: (year) {
              // Update your year value here
              context.read<ProfileCubit>().updateBirthYear(year);
            },
              initialYear: context.read<ProfileCubit>().ageController.text.isNotEmpty
                  ? int.tryParse(context.read<ProfileCubit>().ageController.text) ?? 2002
                  : 2002,
          ),
        ],
      ),
    );
  }
}

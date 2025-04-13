/*
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:daily_expense_tracker_app/features/blocs/category_bloc/category_state.dart';
import 'package:daily_expense_tracker_app/features/categories/data/category_base_repository.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_service/user_service.dart';

import '../../../../core/service/network_info.dart';
import '../../profile/data/profile_repository/profile_base_repository.dart';

part 'category_state.dart.dart';
part 'category_state.freezed.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryBaseRepository _categoryRepository;
  final NetworkBaseInfo _networkInfo;
  CategoryCubit({
    required CategoryBaseRepository categoryRepository,
    required NetworkBaseInfo networkInfo,
  })  : _categoryRepository = categoryRepository,
        _networkInfo = networkInfo,
        super(const CategoryState.initial());

  /// The [GlobalKey] is used to identify the [Form] and
  final formKey = GlobalKey<FormState>();

  /// The [TextEditingController] is used to control the text being edited.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  /// The [User] class is used to manage the user.
  User currentUser = User.empty();

  User updatedUser = User.empty();

  File? selectedImage;

  void init(User user) {
    nameController.text = user.fullName;
    phoneNumberController.text = user.phoneNumber ?? '';
    ageController.text =
        user.birthYear != null ? user.birthYear.toString() : '';
    currentUser = user;
  }

  void updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    User updatedUser = currentUser.copyWith(
      photoUrl: selectedImage?.path ?? currentUser.photoUrl,
      fullName: nameController.text.trim(),
      phoneNumber: phoneNumberController.text.trim(),
      birthYear: int.tryParse(ageController.text.trim()),
    );

    if (updatedUser != currentUser) {
      emit(const ProfileState.loading());

      if (!await _networkInfo.isConnected) {
        return emit(
          const ProfileState.error('Không có kết nối mạng'),
        );
      }

      try {
        if (selectedImage != null) {
          final uploadPicture = await _profileRepository.updateUserPicture(
            user: currentUser,
            imagePath: selectedImage!.path,
          );
          updatedUser = updatedUser.copyWith(photoUrl: uploadPicture);
        }

        await _profileRepository.updateProfile(user: updatedUser);

        selectedImage = null;
        return emit(
            const ProfileState.success('Hồ sơ được cập nhật thành công'));
      } catch (err) {
        return emit(ProfileState.error(err.toString()));
      }
    } else {
      debugPrint('Không có gì thay đổi');
      return emit(
          const ProfileState.success('Không có gì thay đổi trong hồ sơ'));
    }
  }

  void updateBirthYear(int year) {
    ageController.text = year.toString();
  }
}
*/

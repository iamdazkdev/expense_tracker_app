import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/categorys.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id, // id Firestore document
    required String name, // Tên hiển thị
    required String iconName, // FontFamilyName
    required int colorName, // Mã màu dạng int (ARGB)
    String? note,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.empty() {
    return const CategoryModel(
      id: '',
      name: '',
      iconName: 'bus', // Font fallback nếu null
      colorName: 0xFFFF0000, // Default color red
      note: null,
    );
  }

  /// Tạo CategoryModel từ Categorys enum
  factory CategoryModel.fromCategorys({
    required Categorys categorys,
    required String id,
  }) {
    return CategoryModel(
      id: id,
      name: categorys.name,
      iconName: categorys.icon.codePoint.toString(),
      colorName:
          categorys.backgroundColorIcon.toARGB32(), // Store color as ARGB
      note: categorys.note,
    );
  }

  /// Tạo Categorys từ CategoryModel (để chuyển từ mô hình dữ liệu Firestore về enum)
  Categorys toCategorys() {
    return Categorys.values.firstWhere(
      (category) => category.name == name,
      orElse: () => Categorys.others, // Return default if not found
    );
  }
}

extension CategoryModelX on CategoryModel {
  /// Lấy mã màu từ ARGB thành Color
  Color get color => Color(colorName); // Chuyển ARGB (int) thành Color

  /// Lấy icon từ FontFamilyName
  IconData get icon {
    return IconData(
      int.parse(iconName), // Chuyển iconName (String) thành int (codePoint)
      fontFamily: 'FontAwesomeSolid', // FontFamily của FontAwesome
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/categorys.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String uuid,
    required String name,
    required String iconName,
    required int colorName,
    String? note,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.empty() {
    return const CategoryModel(
      uuid: '',
      name: '',
      iconName: 'bus',
      colorName: 0xFFFF0000,
      note: null,
    );
  }

  /// Tạo CategoryModel từ Categorys enum
  factory CategoryModel.fromCategorys({
    required Categorys categorys,
    required String id,
  }) {
    return CategoryModel(
      uuid: id,
      name: categorys.name,
      iconName: categorys.icon.codePoint.toString(),
      colorName:
          categorys.backgroundColorIcon.toARGB32(), // Store color as ARGB
      note: categorys.note,
    );
  }
}

extension CategoryModelX on CategoryModel {
  /// Lấy mã màu từ ARGB thành Color
  Color get color => Color(colorName);
  IconData get icon {
    return IconData(
      int.parse(iconName),
      fontFamily: 'FontAwesomeSolid',
    );
  }
}

extension CategoryModelExtension on CategoryModel {
  Categorys toCategorys() {
    return Categorys.values.firstWhere(
      (category) => category.name == name,
      orElse: () => Categorys.others,
    );
  }
}

extension CategoryModelListExtension on List<CategoryModel> {
  List<Categorys> toCategorysList() {
    return map((e) => e.toCategorys()).toList();
  }
}

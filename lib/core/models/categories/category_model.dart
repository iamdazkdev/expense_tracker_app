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
    required int backgroundColorIcon, // Mã màu dạng int
    String? note,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.empty() {
    return const CategoryModel(
      id: '',
      name: '',
      iconName: '',
      backgroundColorIcon: 0xFFFF0000,
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
      iconName:
          categorys.icon.fontFamily ?? 'FontAwesomeSolid', // fallback nếu null
      backgroundColorIcon: categorys.backgroundColorIcon.value,
      note: categorys.note,
    );
  }
}

extension CategoryModelX on CategoryModel {
  /// Lấy enum Categorys từ categoryIndex
}

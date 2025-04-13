import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:daily_expense_tracker_app/core/models/categories/category_model.dart';
import 'package:daily_expense_tracker_app/features/categories/data/category_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/enum/app_icons.dart';
import '../../../../core/shared/custom_button_actions.dart';

typedef Callback = void Function();

class CategoryForm extends StatefulWidget {
  final CategoryModel? category;
  final Callback? onSave;
  final String? note;
  final bool? isEdit;
  const CategoryForm(
      {super.key, this.category, this.onSave, this.note, this.isEdit});

  @override
  State<StatefulWidget> createState() => _CategoryForm();
}

class _CategoryForm extends State<CategoryForm> {
  late DbFirestoreClientBase _dbFirestoreClientBase;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CategoryRepository _categoryRepository;
  late TextEditingController _nameController;
  late TextEditingController _noteController;

  late CategoryModel categoryModel;

  @override
  void initState() {
    super.initState();
    _dbFirestoreClientBase = DbFirestoreClient();
    _categoryRepository = CategoryRepository(
      dbFirestoreClient: _dbFirestoreClientBase,
      authUser: AuthUser(),
      dbHiveClient: DbHiveClient(),
    );

    categoryModel = widget.category ??
        CategoryModel(
          id: Helper.generateUUID(),
          name: "",
          iconName: "",
          colorName: Colors.blue.toARGB32(),
          note: "",
        );

    _nameController = TextEditingController(text: categoryModel.name);
    _noteController = TextEditingController(text: categoryModel.note);
  }

  void onSave(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      categoryModel = categoryModel.copyWith(
          name: _nameController.text.trim(),
          note: _noteController.text.trim(),
          iconName: "62183");

      if (widget.isEdit != null || widget.isEdit == true) {
        await _categoryRepository.updateCategory(categoryModel);
      } else {
        await _categoryRepository.addCategory(categoryModel);
      }

      if (widget.onSave != null) {
        widget.onSave!();
      }

      Navigator.pop(context);
    }
  }

  void onDelete(BuildContext context) async {
    if (widget.category != null) {
      debugPrint("Id category for delete: ${widget.category!.id}");
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Xoá danh mục'),
            content:
                const Text('Bạn có chắc chắn muốn xoá danh mục này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xoá'),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        await _categoryRepository.deleteCategory(widget.category!.id!);
        if (widget.onSave != null) {
          widget.onSave!(); // Gọi callback để làm mới dữ liệu trong view
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.all(10),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.category != null ? "Chỉnh sửa danh mục" : "Thêm danh mục",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (widget.isEdit ?? false)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onDelete(context);
              },
            ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: categoryModel.color,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.idBadge,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên',
                        hintText: 'Nhập tên của danh mục',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tên không được để trống';
                        }
                        if (value.length > 100) {
                          return 'Tên không được dài quá 100 ký tự';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: categoryModel.color,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      FontAwesomeIcons.noteSticky,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Ghi chú',
                        hintText: 'Nhập ghi chú',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                      ),
                      validator: (value) {
                        if (value != null && value.length > 100) {
                          return 'Ghi chú không được dài quá 100 ký tự';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Colors.primaries.length,
                  itemBuilder: (context, index) {
                    final color = Colors.primaries[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryModel = categoryModel.copyWith(
                            colorName: color.toARGB32(),
                          );
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 2,
                            color: categoryModel.color.toARGB32() ==
                                    color.toARGB32()
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppIcons.icons.length,
                  itemBuilder: (context, index) {
                    final icon = AppIcons.icons[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryModel = categoryModel.copyWith(
                            iconName: icon.codePoint.toString(),
                          );
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 2,
                            color: categoryModel.iconName ==
                                    icon.codePoint.toString()
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          height: 45,
          isFullWidth: true,
          onPressed: () => onSave(context),
          color: Theme.of(context).colorScheme.primary,
          label: "Lưu",
        ),
      ],
    );
  }
}

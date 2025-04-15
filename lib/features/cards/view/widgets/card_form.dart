import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/enum/app_icons.dart';
import '../../../../core/shared/custom_button_actions.dart';
import '../../data/card_repository.dart';

typedef Callback = void Function();

class CardForm extends StatefulWidget {
  final CardModel? card;
  final Callback? onSave;
  final bool? isEdit;

  const CardForm({super.key, this.card, this.onSave, this.isEdit = false});

  @override
  State<StatefulWidget> createState() => _AccountForm();
}

class _AccountForm extends State<CardForm> {
  final _formKey = GlobalKey<FormState>();

  late DbFirestoreClientBase _dbFirestoreClientBase;
  late CardBaseRepository _cardRepository;

  CardModel? _cardModel;
  late TextEditingController _cardNumberController = TextEditingController();
  late TextEditingController _nameCardController;
  late TextEditingController _holderNameController;
  bool _validateCardNumber = true;
  String _formattedCardNumber = '';
  final int _cardLength = 16;
  @override
  void initState() {
    super.initState();
    _dbFirestoreClientBase = DbFirestoreClient();
    _cardRepository = CardRepository(
      dbFirestoreClient: _dbFirestoreClientBase,
      authUser: AuthUser(),
    );
    if (widget.card != null) {
      _cardModel = CardModel(
          uuid: widget.card!.uuid,
          name: widget.card!.name,
          holderName: widget.card!.holderName,
          accountNumber: widget.card!.accountNumber,
          color: widget.card!.color);
      _nameCardController = TextEditingController(text: _cardModel!.name);
      _holderNameController =
          TextEditingController(text: _cardModel!.holderName);
      _cardNumberController =
          TextEditingController(text: _cardModel!.accountNumber);
    } else {
      _cardModel = CardModel.empty();
      _nameCardController = TextEditingController();
      _holderNameController = TextEditingController();
      _cardNumberController = TextEditingController();
    }
    _cardNumberController.addListener(() {
      final text = _cardNumberController.text;
      if (text.isNotEmpty) {
        final formattedText = _formatCardNumber(text);
        if (formattedText != _formattedCardNumber) {
          setState(() {
            _formattedCardNumber = formattedText;
            _cardNumberController.value = TextEditingValue(
              text: _formattedCardNumber,
              selection:
                  TextSelection.collapsed(offset: _formattedCardNumber.length),
            );
          });
        }
      }
    });
  }

  void onSave(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_cardModel == null) {
        debugPrint("Card model is null");
      }
      _cardModel = _cardModel!.copyWith(
        uuid: Helper.generateUUID(),
        name: _nameCardController.text.trim(),
        holderName: _holderNameController.text.trim(),
        accountNumber: _cardNumberController.text.trim(),
        color: _cardModel!.color,
      );
      if (widget.isEdit == true) {
        debugPrint("Trying to Update Card: ${_cardModel!.name}");
        await _cardRepository.updateCard(_cardModel!);
      } else {
        debugPrint("Trying to Add Card");
        await _cardRepository.addCard(_cardModel!);
      }
      if (widget.onSave != null) {
        widget.onSave!();
      }
      Navigator.pop(context);
    }
  }

  // Hàm định dạng số thẻ
  String _formatCardNumber(String input) {
    String cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = '';
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += cleaned[i];
    }

    return formatted;
  }

  // Kiểm tra tính hợp lệ của số thẻ
  bool _isValidCardNumber(String cardNumber) {
    String cleanedNumber = cardNumber.replaceAll(' ', '');
    if (cleanedNumber.length > 16) {
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedNumber)) {
      return false;
    }
    return true;
  }

  void onDelete(BuildContext context) async {
    if (widget.card != null) {
      debugPrint("Id category for delete: ${widget.card!.uuid}");
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
        await _cardRepository.deleteCard(widget.card!.uuid!);
        if (widget.onSave != null) {
          widget.onSave!(); // Gọi callback để làm mới dữ liệu trong view
        }
        setState(() {
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cardModel == null) {
      return const CircularProgressIndicator();
    }
    return AlertDialog(
      title: Row(
        children: [
          Text(
            widget.card != null ? "Chỉnh sửa thẻ" : "Thêm thẻ mới",
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
      scrollable: true,
      insetPadding: const EdgeInsets.all(20),
      content: Form(
        // Bọc trong Form
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: _cardModel!.getColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _nameCardController,
                      decoration: InputDecoration(
                        labelText: 'Tên thẻ',
                        hintText: 'Nhập tên thẻ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tên thẻ';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _holderNameController,
                decoration: InputDecoration(
                  labelText: 'Tên chủ thẻ',
                  hintText: 'Nhập tên chủ thẻ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                ),
                /*onChanged: (text) {
                  setState(() {
                    _cardModel = _cardModel!.copyWith(holderName: text.trim());
                  });
                },*/
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên chủ thẻ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText:
                      'Số thẻ (${_formattedCardNumber.replaceAll(' ', '').length}/$_cardLength)', // Hiển thị số ký tự đã nhập
                  hintText: '(Ví dụ: 1234 5678 9012 3456)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  errorText: _validateCardNumber ? null : 'Số thẻ không hợp lệ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly, // Chỉ cho phép nhập số
                ],
                onChanged: (text) {
                  setState(() {
                    _validateCardNumber = _isValidCardNumber(text);
                  });
                },
              ),
              const SizedBox(height: 20),
              // Color picker
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Colors.primaries.length,
                  itemBuilder: (BuildContext context, index) => Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.5, vertical: 2.5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _cardModel = _cardModel!.copyWith(
                              color: Colors.primaries[index].toARGB32());
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.primaries[index],
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            width: 2,
                            color: _cardModel!.getColor.toARGB32() ==
                                    Colors.primaries[index].toARGB32()
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Icon picker
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppIcons.icons.length,
                  itemBuilder: (BuildContext context, index) => Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 2.5, vertical: 2.5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // _cardModel!.icon = AppIcons.icons[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          AppIcons.icons[index],
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
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
          onPressed: () {
            onSave(context);
          },
          color: Theme.of(context).colorScheme.primary,
          label: widget.card != null ? "Lưu" : "Thêm",
        )
      ],
    );
  }
}

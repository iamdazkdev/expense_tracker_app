import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  late TextEditingController _limitController;
  // late TextEditingController _spendingLimit;
  bool _validateCardNumber = true;
  String _formattedCardNumber = '';
  final int _cardLength = 16;
  bool isSaving = false;

  double _spendingLimit = 5000000;
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
          balance: widget.card!.balance,
          spendingLimit: widget.card!.spendingLimit,
          income: widget.card!.income,
          expense: widget.card!.expense,
          color: widget.card!.color,
          userId: widget.card!.userId);
      _nameCardController = TextEditingController(text: _cardModel!.name);
      _holderNameController =
          TextEditingController(text: _cardModel!.holderName);
      _cardNumberController =
          TextEditingController(text: _cardModel!.accountNumber);
      debugPrint("Spend limit: ${_cardModel!.spendingLimit.toString()}");
      _limitController =
          TextEditingController(text: _cardModel!.spendingLimit.toString());
    } else {
      _cardModel = CardModel.empty();
      _nameCardController = TextEditingController();
      _holderNameController = TextEditingController();
      _cardNumberController = TextEditingController();
      _limitController =
          TextEditingController(text: _spendingLimit.toInt().toString());
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

  void updateSpendingLimit() {
    final rawValue =
        _limitController.text.replaceAll('.', '').replaceAll(' ', '');
    final parsedValue = double.tryParse(rawValue);
    if (parsedValue != null) {
      setState(() {
        _spendingLimit = parsedValue;
      });
    } else {
      // Handle invalid number input if needed
      debugPrint("Invalid number input");
    }
  }

  Future<void> onSave(BuildContext context) async {
    if (isSaving) return; // Ngăn double-tap
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || !_validateCardNumber) {
      debugPrint("Form không hợp lệ");
      return;
    }

    setState(() => isSaving = true);

    try {
      final updatedCard = _cardModel!.copyWith(
        uuid: widget.isEdit == true ? widget.card!.uuid : Helper.generateUUID(),
        name: _nameCardController.text.trim(),
        userId: AuthUser().currentUser!.uid,
        holderName: _holderNameController.text.trim(),
        accountNumber: _cardNumberController.text.trim(),
        color: _cardModel!.color,
        isDefault: widget.isEdit == true
            ? (widget.card!.isDefault != false ? true : false)
            : false,
        spendingLimit: _limitController.text.trim().toDoubleFromCurrency(),
      );

      if (widget.isEdit == true) {
        debugPrint("Cập nhật thẻ: ${updatedCard.toString()}");
        await _cardRepository.updateCard(updatedCard);
      } else {
        debugPrint("Thêm thẻ mới");
        await _cardRepository.addCard(updatedCard);
      }

      widget.onSave?.call();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Lỗi khi lưu thẻ: $e");
    } finally {
      setState(() => isSaving = false);
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
    _limitController.dispose();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Đặt hạn mức",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _spendingLimit.clamp(0, 100000000),
                    min: 0,
                    max: 100000000, // 10 triệu
                    divisions: 100,
                    label: _spendingLimit.toInt().toCurrencyWithSymbol(),
                    onChanged: (value) {
                      setState(() {
                        _spendingLimit = value;
                        final formatted =
                            value.toInt().toCurrencyWithSymbol(symbol: '');
                        _limitController.value = TextEditingValue(
                          text: formatted,
                          selection:
                              TextSelection.collapsed(offset: formatted.length),
                        );
                      });
                    },
                  ),
                  Row(
                    children: [
                      const Text("Hạn mức:"),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _limitController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixText: "VND",
                          ),
                          onChanged: (value) {
                            updateSpendingLimit();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )
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

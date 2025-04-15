import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/view/widgets/card_form.dart';
import 'package:daily_expense_tracker_app/features/cards/view/widgets/confirm_model_widget.dart';
import 'package:daily_expense_tracker_app/features/cards/view/widgets/currency_text_widget.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/enum/colors.dart';
import '../data/card_base_repository.dart';
import '../data/card_repository.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late DbFirestoreClientBase _dbFirestoreClient;
  late CardBaseRepository _cardRepository;

  Future<List<CardModel>> loadData() async {
    try {
      final result = await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "cards",
        mapper: (data, documentId) => CardModel.fromJson(data!),
        orderByField: "name",
      );
      debugPrint("result: ${result.length}");
      return result;
    } catch (err) {
      throw Exception('Failed to load cards: $err');
    }
  }

  @override
  void initState() {
    super.initState();
    _dbFirestoreClient = DbFirestoreClient();
    _cardRepository = CardRepository(
      dbFirestoreClient: _dbFirestoreClient,
      authUser: AuthUser(),
    );
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quản lý thẻ",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<CardModel>>(
            future: loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Chưa có thẻ nào',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                );
              } else {
                final List<CardModel> listCards = snapshot.data!;
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  itemCount: listCards.length,
                  itemBuilder: (builder, index) {
                    CardModel card = listCards[index];
                    debugPrint("Card Number: ${card.accountNumber}");
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (builder) => CardForm(
                            isEdit: true,
                            card: card,
                            onSave: () {
                              setState(() {});
                            },
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: card.getColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.holderName.isEmpty
                                              ? "---"
                                              : card.holderName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          card.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          card.accountNumber.isEmpty
                                              ? "---"
                                              : card.accountNumber
                                                  .maskAccount(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Tổng số dư",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                CurrencyText(
                                  card.balance ?? 0,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Thu nhập",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          CurrencyText(
                                            card.income ?? 0,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: ThemeColors.success),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Chi tiêu",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          CurrencyText(
                                            card.expense ?? 0,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: ThemeColors.error),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: 15,
                            bottom: 40,
                            child: Icon(
                              FontAwesomeIcons.wallet,
                              size: 20,
                              color: card.getColor,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                _showOptions(context, card);
                              },
                              icon: const Icon(
                                Icons.wallet,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) => CardForm(
              onSave: () {
                setState(() {});
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showOptions(BuildContext context, CardModel card) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: ThemeColors.primary),
                title: const Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context); // Đóng BottomSheet
                  // TODO: show form chỉnh sửa ở đây
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: ThemeColors.error),
                title: const Text('Xoá'),
                onTap: () async {
                  Navigator.pop(context); // Đóng BottomSheet trước
                  _confirmDelete(context, card);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, CardModel card) {
    ConfirmModal.showConfirmDialog(
      context,
      title: "Bạn có chắc chắn không?",
      content: const Text(
        "Tất cả các khoản thanh toán liên quan đến tài khoản này sẽ bị xóa.",
      ),
      onConfirm: () async {
        await _cardRepository.deleteCard(card.uuid!);
      },
      onCancel: () {},
    );
  }
}

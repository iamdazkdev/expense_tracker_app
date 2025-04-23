import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/enum/colors.dart';
import '../../../../core/models/cards/card_model.dart';
import 'card_form.dart';
import 'currency_text_widget.dart';

class CardDisplayWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onCardSelect;
  final VoidCallback onCardOptions;

  const CardDisplayWidget({
    super.key,
    required this.card,
    required this.onCardSelect,
    required this.onCardOptions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (builder) => CardForm(
            isEdit: true,
            card: card,
            onSave: () {
              onCardSelect();
            },
          ),
        );
      },
      onTap: onCardOptions,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.holderName.isEmpty ? "---" : card.holderName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        Text(
                          card.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          card.accountNumber.isEmpty
                              ? "---"
                              : card.accountNumber.maskAccount(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tổng số dư",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          CurrencyText(
                            card.getBalance,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hạn mức",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          CurrencyText(
                            card.spendingLimit ?? 0,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Thu nhập",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Chi tiêu",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
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
                ),
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
              onPressed: () {},
              icon: const Icon(
                Icons.wallet,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../../core/models/categories/category_model.dart';
import '../../../../core/router/router.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/transaction_bloc/transaction_cubit.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late List<CategoryModel> listCategories = [];
  late List<CardModel> listCards = [];
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    context.read<TransactionCubit>().init();
    listCategories = await getCachedCategoryModels();
    listCards = await getCachedCardModels();
  }

  Future<List<CategoryModel>> getCachedCategoryModels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList("cached_categories");
    if (jsonList == null) return [];
    return jsonList.map((e) => CategoryModel.fromJson(json.decode(e))).toList();
  }

  Future<List<CardModel>> getCachedCardModels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList("cached_cards");
    if (jsonList == null) return [];
    return jsonList.map((e) => CardModel.fromJson(json.decode(e))).toList();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    const iconItemHeight = 35.0;
    const iconItemWidth = 35.0;
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 15);
    final backgroundItem = context.colorScheme.surface;

    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => current is LoadTransaction,
      builder: (context, state) {
        final categorys = state.mapOrNull(
          loadTransaction: (state) => state.categorys,
        );
        final transactionCategory = state.mapOrNull(
          loadTransaction: (state) => state.transactionCategory,
        );

        final transactionDate = state.mapOrNull(
          loadTransaction: (state) => state.transactionDate,
        );

        final cardID = state.mapOrNull(
          loadTransaction: (state) => state.cardID,
        );
        final selectedCard = listCards.firstWhere(
          (card) => card.uuid == cardID,
          orElse: () => CardModel(
              name: 'Loại thẻ', holderName: '', accountNumber: '', color: 12),
        );
        Categorys? getCategoryByName(String name) {
          return Categorys.values.firstWhere(
            (e) => e.name.toLowerCase().trim() == name.toLowerCase().trim(),
            orElse: () => Categorys.others,
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMoneyTextField(context),
            const SizedBox(height: 20),
            Column(
              children: [
                CustomItemButton(
                  text: categorys!.name,
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: Colors.white,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: categorys.backgroundColorIcon,
                  backgroundItem: backgroundItem,
                  icon: categorys.icon,
                  onPressed: () => _showModalSheetCategory(context),
                ),
                CustomItemButton(
                  text: transactionCategory!.name,
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: Colors.white,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: transactionCategory.backgroundIcon,
                  backgroundItem: backgroundItem,
                  icon: transactionCategory.icon,
                  onPressed: () => _showModalSheetTransactionCategory(context),
                ),
                CustomItemButton(
                  text: listCards
                      .firstWhere(
                        (card) => card.uuid == cardID,
                        orElse: () => CardModel(
                            name: 'Loại thẻ',
                            holderName: '',
                            accountNumber: '',
                            color: 123),
                      )
                      .name,
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: Colors.white,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: Colors.blue,
                  backgroundItem: backgroundItem,
                  icon: FontAwesomeIcons.simCard,
                  onPressed: () => _showModalSheetTransactionCards(context),
                ),
                CustomItemButton(
                  text: transactionDate!.formattedDateOnly,
                  padding: padding,
                  iconSize: iconSize,
                  iconColor: context.colorScheme.surface,
                  iconItemWidth: iconItemWidth,
                  iconItemHeight: iconItemHeight,
                  backgroundIcon: context.colorScheme.outline,
                  backgroundItem: backgroundItem,
                  icon: FontAwesomeIcons.calendarDay,
                  onPressed: () => _showPickerDate(context, transactionDate),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  _buildMoneyTextField(BuildContext context) {
    return Container(
      height: 70,
      width: context.screenWidth(0.65),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: context.colorScheme.surface,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 18),
          Flexible(
            child: CustomTextFormField(
              fontSize: 30,
              maxLines: 1,
              hintText: '0.00',
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w800,
              keyboardType: TextInputType.number,
              contentPadding: const EdgeInsets.only(
                right: 15,
                left: 0,
              ),
              controller: context.read<TransactionCubit>().amountController,
              prefixText: NumberFormat.compactSimpleCurrency(locale: 'en')
                  .currencySymbol,
            ),
          )
        ],
      ),
    );
  }

  void _showModalSheetCategory(BuildContext context) {
    // Hàm tìm Categorys từ tên
    Categorys? getCategoryByName(String name) {
      return Categorys.values.firstWhere(
        (e) => e.name.toLowerCase().trim() == name.toLowerCase().trim(),
        orElse: () => Categorys.others,
      );
    }

    Alerts.showSheet(
      context: context,
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: listCategories.length,
          itemBuilder: (context, index) {
            CategoryModel category = listCategories[index];
            final matchedEnum = getCategoryByName(category.name);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomItemButton(
                text: category.name,
                icon: matchedEnum!.icon,
                iconColor: Colors.white,
                backgroundItem: Colors.transparent,
                backgroundIcon: matchedEnum.backgroundColorIcon,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                onPressed: () {
                  context.read<TransactionCubit>().onCategoryChanged(category);
                  context.pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showModalSheetTransactionCategory(BuildContext context) {
    Alerts.showSheet(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          children: TransactionType.values.map((transactionCategory) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomItemButton(
                text: transactionCategory.name,
                iconColor: Colors.white,
                icon: transactionCategory.icon,
                backgroundIcon: transactionCategory.backgroundIcon,
                backgroundItem: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                onPressed: () {
                  context
                      .read<TransactionCubit>()
                      .onTransactionCategoryChanged(transactionCategory);

                  context.pop();
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showModalSheetTransactionCards(BuildContext context) {
    Alerts.showSheet(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "Chọn thẻ giao dịch",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...listCards.map(
              (card) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomItemButton(
                  text: card.name,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.wallet,
                  backgroundIcon: card.getColor.withOpacity(0.7),
                  backgroundItem: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  onPressed: () {
                    /// Gọi xử lý khi chọn thẻ, ví dụ:
                    context.read<TransactionCubit>().onCardChanged(card);
                    context.pop(); // đóng modal sau khi chọn
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showPickerDate(
    BuildContext context,
    DateTime initialDate,
  ) {
    return Alerts.showPickerTransactionDate(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      onDateSelected: (DateTime dateTime) {
        context.read<TransactionCubit>().onTransactionDateChanged(dateTime);
      },
    );
  }
}

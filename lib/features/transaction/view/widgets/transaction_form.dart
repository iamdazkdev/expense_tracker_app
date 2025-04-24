import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/core/router/app_route.dart';
import 'package:daily_expense_tracker_app/features/cards/view/widgets/card_display_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../../core/helper/shared_prefs_storage.dart';
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
    listCategories = await SharedPrefsStorage.getCachedCategoryModels();
    listCards = await SharedPrefsStorage.getCachedCardModels();
    _debugCards();
  }

  void _debugCards() async {
    final cards = await SharedPrefsStorage.getCachedCardModels();
    for (var card in cards) {
      if (kDebugMode) {
        print(card.toJson());
      }
    }
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
        final listCards = state.mapOrNull(
          loadTransaction: (state) => state.listCards,
        );

        if (listCards == null) {
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Thêm thẻ để tiếp tục"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // Dùng màu primaryContainer để ôn hoà với light & dark mode
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                context.pushNamed(RoutesName.cards);
              },
            ),
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
                  onPressed: () => _showModalSheetTransactionType(context),
                ),
                CustomItemButton(
                  text: listCards
                      .firstWhere(
                        (card) => card.uuid == cardID,
                        orElse: () => CardModel(
                            name: 'Loại thẻ',
                            holderName: '',
                            accountNumber: '',
                            color: 123,
                            uuid: '',
                            userId: ''),
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
          itemCount: categorys.length,
          itemBuilder: (context, index) {
            final category = categorys[index];
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
                  // context.read<TransactionCubit>().onCategoryChanged(category);
                  context.read<TransactionCubit>().onCategorysChanged(category);
                  context.pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showModalSheetTransactionType(BuildContext context) {
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
                      .onTransactionTypeChanged(transactionCategory);

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
    Alerts.showSheetAllScreen(
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 12, right: 12),
        child: ConstrainedBox(
          // Giới hạn chiều cao tối đa của sheet, ví dụ 80% chiều cao màn hình
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
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
                // Danh sách card
                ...listCards.map(
                  (card) => CardDisplayWidget(
                    card: card,
                    onCardSelect: () {},
                    onCardOptions: () {
                      context.read<TransactionCubit>().onCardChanged(card);
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
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

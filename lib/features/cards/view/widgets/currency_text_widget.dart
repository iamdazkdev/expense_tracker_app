import 'package:currency_picker/currency_picker.dart';
import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:daily_expense_tracker_app/features/blocs/main_bloc/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyText extends StatelessWidget {
  final double? amount;
  final TextStyle? style;
  final TextOverflow? overflow;
  final CurrencyService currencyService = CurrencyService();

  CurrencyText(this.amount, {super.key, this.style, this.overflow});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        Currency? currency = currencyService.findByCode("USD");
        return Text(
          amount == null
              ? "${currency!.symbol} "
              : amount!.toCurrencyWithSymbol(),
          /*CurrencyHelper.format(amount!,
                  name: currency?.code,
                  symbol: currency?.symbol,
                  locale: 'en_IN')*/
          style: style,
          overflow: overflow,
        );
      },
    );
  }
}

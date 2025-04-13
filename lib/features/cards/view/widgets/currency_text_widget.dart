import 'package:currency_picker/currency_picker.dart';
import 'package:daily_expense_tracker_app/features/blocs/main_bloc/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/currency_helper.dart';

class CurrencyText extends StatelessWidget {
  final double? amount;
  final TextStyle? style;
  final TextOverflow? overflow;
  final CurrencyService currencyService = CurrencyService();

  CurrencyText(this.amount, {super.key, this.style, this.overflow});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      Currency? currency = currencyService.findByCode("USD");
      return Text(
        amount == null
            ? "${currency!.symbol} "
            : CurrencyHelper.format(amount!,
                name: currency?.code, symbol: currency?.symbol),
        style: style,
        overflow: overflow,
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/router/router.dart';
import '../../../../core/shared/custom_material_button.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/state_bloc/state_cubit.dart';
import 'widgets.dart';

class HeaderAppBarFilter extends StatelessWidget {
  const HeaderAppBarFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Giao dịch',
          style: AppTextStyle.title.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        CustomIconBottom(
          icon: FontAwesomeIcons.filter,
          onPressed: () => _showModalSheetFilter(context),
        )
      ],
    );
  }

  void _showModalSheetFilter(BuildContext context) {
    String? selectedRange;

    Alerts.showSheet(
      height: MediaQuery.of(context).size.height * 0.8,
      context: context,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilterForm(
                onRangeSelected: (value) {
                  selectedRange = value;
                },
              ),
              CustomMaterialButton(
                text: 'Xong',
                onPressed: () {
                  context.pop();
                  final stateCubit = context.read<StateCubit>();
                  if (selectedRange != null) {
                    stateCubit.applyQuickFilter(selectedRange!);
                  }
                  stateCubit.applyFilter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

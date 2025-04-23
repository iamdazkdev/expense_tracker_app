import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/state_bloc/state_cubit.dart';

class FilterForm extends StatefulWidget {
  const FilterForm({super.key, this.onRangeSelected});
  final void Function(String?)? onRangeSelected;

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  late DateTime startDate;
  late DateTime endDate;
  String? selectedBox;

  @override
  void initState() {
    super.initState();
    startDate = context.read<StateCubit>().startDate;
    endDate = context.read<StateCubit>().endDate;
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 16.0;
    const iconItemHeight = 35.0;
    const iconItemWidth = 35.0;
    const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 15);
    final backgroundItem = context.colorScheme.surface;

    return Column(
      children: [
        _buildHeaderText('Ngày kết thúc'),
        const SizedBox(height: 10),
        CustomItemButton(
          text: startDate.formattedDateOnly,
          padding: padding,
          iconSize: iconSize,
          iconColor: Colors.white,
          iconItemWidth: iconItemWidth,
          iconItemHeight: iconItemHeight,
          backgroundIcon: context.colorScheme.outline,
          backgroundItem: backgroundItem,
          icon: FontAwesomeIcons.wallet,
          onPressed: selectedBox == null
              ? () => _showPickerDate(context, startDate, true)
              : null,
        ),
        const SizedBox(height: 18),
        _buildHeaderText('Ngày bắt đầu'),
        const SizedBox(height: 10),
        CustomItemButton(
          text: endDate.formattedDateOnly,
          padding: padding,
          iconSize: iconSize,
          iconColor: Colors.white,
          iconItemWidth: iconItemWidth,
          iconItemHeight: iconItemHeight,
          backgroundIcon: context.colorScheme.outline,
          backgroundItem: backgroundItem,
          icon: FontAwesomeIcons.wallet,
          onPressed: selectedBox == null
              ? () => _showPickerDate(context, endDate, false)
              : null,
        ),
        _buildRangeSelector(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildHeaderText(String title) {
    return Row(children: [
      const SizedBox(width: 8),
      Text(title, style: AppTextStyle.body)
    ]);
  }

  Widget _buildRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 8),
        _buildRangeBox("1 tuần"),
        _buildRangeBox("1 tháng"),
        _buildRangeBox("1 năm"),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildRangeBox(String title) {
    final isSelected = selectedBox == title;
    final cs = Theme.of(context).colorScheme;

    // Màu nền và viền khi chọn / không chọn
    final bgColor = isSelected ? cs.primaryContainer : cs.surfaceVariant;
    final borderColor = isSelected ? cs.primary : cs.outline;
    final textColor = isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBox = isSelected ? null : title;
        });
        widget.onRangeSelected?.call(selectedBox);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Text(
          title,
          style: AppTextStyle.body.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _showPickerDate(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) {
    return Alerts.showPickerTransactionDate(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      initialDate: initialDate,
      onDateSelected: (newDate) {
        if (isStartDate) {
          context.read<StateCubit>().newStartDate = newDate;
          setState(() => startDate = newDate);
        } else {
          context.read<StateCubit>().newEndDate = newDate;
          setState(() => endDate = newDate);
        }
      },
    );
  }
}

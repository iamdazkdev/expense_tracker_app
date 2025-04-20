/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/shared/shared.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../../core/utils/alerts/alerts.dart';
import '../../../blocs/state_bloc/state_cubit.dart';

class FilterForm extends StatefulWidget {
  const FilterForm({super.key});

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  late DateTime startDate;
  late DateTime endDate;

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
          onPressed: () => _showPickerDate(context, startDate, true),
        ),
        const SizedBox(height: 15),
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
          onPressed: () => _showPickerDate(context, endDate, false),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildHeaderText(String title) {
    return Row(children: [
      const SizedBox(width: 8),
      Text(title, style: AppTextStyle.body)
    ]);
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
*/
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

  // Thêm biến để theo dõi box nào được chọn
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
        const SizedBox(height: 15),
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
        const SizedBox(height: 15),
        _buildOrangeBorderBoxes(),
      ],
    );
  }

  Widget _buildHeaderText(String title) {
    return Row(children: [
      const SizedBox(width: 8),
      Text(title, style: AppTextStyle.body)
    ]);
  }

  Widget _buildOrangeBorderBoxes() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Đảm bảo các Box cách đều nhau
      children: [
        SizedBox(
          width: 15,
        ),
        _buildOrangeBorderBox("1 tuần"),
        _buildOrangeBorderBox("1 tháng"),
        _buildOrangeBorderBox("1 năm"),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }

  Widget _buildOrangeBorderBox(String title) {
    bool isSelected = selectedBox == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBox = isSelected ? null : title;
        });

        // Gửi dữ liệu về cha
        if (widget.onRangeSelected != null) {
          widget.onRangeSelected!(selectedBox);
        }

        /*if (!isSelected) {
          context.read<StateCubit>().applyQuickFilter(title);
        }*/
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 1.5),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.grey[200],
        ),
        child: Text(
          title,
          style: AppTextStyle.body.copyWith(
            color: isSelected ? Colors.orange : Colors.black,
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

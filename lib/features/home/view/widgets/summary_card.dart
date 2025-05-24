import 'package:auth_user/auth_user.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/models/transactions/transaction_model.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../../blocs/state_bloc/state_cubit.dart';
import '../../../statisticals/data/stat_comparison_utils.dart';
import '../../../statisticals/data/statistical_utils.dart';
import '../../../statisticals/view/statisticals_view.dart';
import 'widgets.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({super.key});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  late DbFirestoreClientBase _dbFirestoreClient;
  @override
  void initState() {
    // TODO: implement initState
    _dbFirestoreClient = DbFirestoreClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateCubit, StateState>(
      builder: (context, state) {
        final startDate = state.maybeMap(
          initial: (state) => context.read<StateCubit>().startDate,
          dateChanged: (state) => state.startDate,
          orElse: () => context.read<StateCubit>().startDate,
        );

        final endDate = state.maybeMap(
          initial: (state) => context.read<StateCubit>().endDate,
          dateChanged: (state) => state.endDate,
          orElse: () => context.read<StateCubit>().endDate,
        );

        final List<Transaction>? allTransactions = state.mapOrNull(
          loaded: (state) => state.transactions,
        );

        return Container(
          height: context.screenHeight(0.4),
          width: context.screenWidth(0.9),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Text(
                {
                  endDate.formattedDateOnly,
                  startDate.formattedDateOnly,
                }.join(' - '),
                style: AppTextStyle.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                allTransactions?.toCalcTotals().amount.toCurrencyWithSymbol() ??
                    '0.00',
                style: AppTextStyle.title3,
              ),
              const SizedBox(height: 10.0),
              BlocBuilder<StateCubit, StateState>(
                builder: (context, state) {
                  return state.maybeMap(
                    loaded: (loaded) => StateBarChart(
                      chartData: loaded.chartData,
                    ),
                    loading: (_) => StateBarChart(
                      chartData: {DateTime.now(): 0.0},
                    ),
                    error: (error) => Center(child: Text(error.message)),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  FontAwesomeIcons.chartLine,
                ),
                label: const Text("Xem thống kê chi tiêu"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                onPressed: () async {
                  final transactions =
                      await _dbFirestoreClient.getQueryOrderBy<Transaction>(
                    collectionPath: 'transactions',
                    field: 'userId',
                    isEqualTo: AuthUser().currentUser!.uid,
                    descending: true,
                    orderByField: 'amount',
                    mapper: (data, documentId) => Transaction.fromJson(data!),
                  );
                  final now = DateTime.now();
                  // Generate comparison data for week, month, and year
                  final weeklyData =
                      generateComparisonData(transactions, now, 'week');
                  final monthlyData =
                      generateComparisonData(transactions, now, 'month');
                  final yearlyData =
                      generateComparisonData(transactions, now, 'year');
                  final weeklyCategoryBreakdown =
                      StatisticalUtils.generateCategorySummaryByName(
                          transactions);
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatisticalView(
                          weeklyData: weeklyData,
                          monthlyData: monthlyData,
                          yearlyData: yearlyData,
                        ),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

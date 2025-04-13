import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/enum.dart';
import 'transaction_hive_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String? uuid,
    required String? userId,
    required double amount,
    required String categoryName,
    @TimestampConverter() required DateTime date,
    required int categorysIndex,
    required TransactionType category,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  factory Transaction.empty() {
    return Transaction(
      uuid: '',
      userId: '',
      amount: 0.0,
      date: DateTime.now(),
      categorysIndex: 0,
      category: TransactionType.expense,
      categoryName: '',
    );
  }

  factory Transaction.fromHiveModel(TransactionHive transactionHive) {
    return Transaction(
      uuid: transactionHive.uuid,
      userId: transactionHive.userId,
      amount: transactionHive.amount,
      date: transactionHive.date,
      categorysIndex: transactionHive.categorysIndex,
      category: transactionHive.category == CategoryHive.expense
          ? TransactionType.expense
          : TransactionType.income,
      categoryName: transactionHive.categoryName,
    );
  }
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp value) => value.toDate();

  @override
  Timestamp toJson(DateTime value) => Timestamp.fromDate(value);
}

extension TransactionTotalsExtension on List<Transaction> {
  Transaction toCalcTotals() {
    return Transaction(
      uuid: '',
      userId: '',
      amount: fold(
        0,
        (previousValue, element) {
          if (element.category == TransactionType.expense) {
            return previousValue - element.amount;
          } else {
            return previousValue + element.amount;
          }
        },
      ),
      date: DateTime.now(),
      categorysIndex: 0,
      category: TransactionType.expense,
      categoryName: '',
    );
  }
}

extension TransactionExtension on Transaction {
  TransactionHive toHiveModel() {
    return TransactionHive(
      uuid: uuid!,
      userId: userId ?? '',
      amount: amount,
      date: date,
      categorysIndex: categorysIndex,
      category: category == TransactionType.expense
          ? CategoryHive.expense
          : CategoryHive.income,
      categoryName: categoryName,
    );
  }
}

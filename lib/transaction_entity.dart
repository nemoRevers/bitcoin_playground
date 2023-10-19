import 'package:bitcoin_playground/tokens.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_entity.g.dart';

@JsonSerializable()
class TransactionEntity {
  final String transactionId;
  final DateTime date;
  final double amountCrypto;
  final double amountDollar;
  final double fee;
  final String fromAddress;
  final String toAddress;
  final Tokens token;

  TransactionEntity({
    required this.transactionId,
    required this.date,
    required this.amountCrypto,
    required this.amountDollar,
    required this.fee,
    required this.fromAddress,
    required this.toAddress,
    required this.token,
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return _$TransactionEntityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TransactionEntityToJson(this);
}

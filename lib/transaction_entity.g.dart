// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionEntity _$TransactionEntityFromJson(Map<String, dynamic> json) =>
    TransactionEntity(
      transactionId: json['transactionId'] as String,
      date: DateTime.parse(json['date'] as String),
      amountCrypto: (json['amountCrypto'] as num).toDouble(),
      amountDollar: (json['amountDollar'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      fromAddress: json['fromAddress'] as String,
      toAddress: json['toAddress'] as String,
      token: $enumDecode(_$TokensEnumMap, json['token']),
    );

Map<String, dynamic> _$TransactionEntityToJson(TransactionEntity instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'date': instance.date.toIso8601String(),
      'amountCrypto': instance.amountCrypto,
      'amountDollar': instance.amountDollar,
      'fee': instance.fee,
      'fromAddress': instance.fromAddress,
      'toAddress': instance.toAddress,
      'token': _$TokensEnumMap[instance.token]!,
    };

const _$TokensEnumMap = {
  Tokens.bitcoin: 'bitcoin',
  Tokens.ethereum: 'ethereum',
  Tokens.litecoin: 'litecoin',
  Tokens.neo: 'neo',
  Tokens.steller: 'steller',
};

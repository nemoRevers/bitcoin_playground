import 'dart:typed_data';

import 'package:bitcoin_playground/transaction_entity.dart';

abstract class Web3ClientProvider {
  Future<void> sendTransaction({
    required String privateKey,
    required String toAddress,
    required double amount,
  });

  Future<Uint8List> signTransaction({
    required String privateKey,
    required Map<String, dynamic> transactionParams,
  });

  Future<int> getBalance(String hex);

  Stream<TransactionEntity> watchAllTransactions();

  Future<double> estimateTransactionFee(String from, String to, double amount);
}

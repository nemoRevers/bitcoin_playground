import 'dart:convert';
import 'dart:typed_data';

import 'package:bitcoin_playground/bitcoin_key_generator_repository_impl.dart';
import 'package:bitcoin_playground/transaction_entity.dart';
import 'package:bitcoin_playground/web3client_provider.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';

import 'models/fee_rate.dart';
import 'models/utxo.dart';

class BitcoinClientProviderImpl implements Web3ClientProvider {
  final String baseUri;
  final NetworkType network;

  BitcoinClientProviderImpl.testnet()
      : baseUri = 'https://blockstream.info/testnet/api/',
        network = testnet;

  @override
  Future<double> estimateTransactionFee(
      String from, String to, double amount) async {
    final int numberOfInputs = (await _getWalletUTXOs(from)).length;
    final List<FeeRate> rates = await _getTransactionFeeRates();
    const int txInitialWeight = 40;
    const int p2wpkhAddition = 2;
    const int weightPerInput = 272;
    const int weightPerOutput = 124;

    final int weight = txInitialWeight +
        (weightPerInput * numberOfInputs) +
        (weightPerOutput * 2) +
        p2wpkhAddition;

    return _estimateTxFeeFromWeight(
      satoshiPerVb: rates.first.satoshiPerVb,
      txWeight: weight,
    ).toDouble();
  }

  @override
  Future<int> getBalance(String hex) async {
    final String rawUri = '$baseUri/address/$hex';
    final Uri uri = Uri.parse(rawUri);

    final response = await get(uri);
    final data = json.decode(response.body);
    print(data);
    final balance = data['chain_stats']['funded_txo_sum'] -
        data['chain_stats']['spent_txo_sum'];

    return balance;
  }

  @override
  Future<void> sendTransaction({
    required String privateKey,
    required String toAddress,
    required double amount,
  }) async {
    ///TODO(nemoRevers): use DI for repository
    final repo = BitcoinKeyGeneratorRepositoryImpl(testnet);
    final fromPublic = repo.getPublicKey(privateKey);
    final fromAddress = repo.getAddress(privateKey);

    ///TODO(nemoRevers): converter btcToSatoshi
    final Transaction tx = await _createTransaction(
      fromBech32: fromAddress,
      fromPublic: fromPublic,
      fromPrivate: privateKey,
      toBech32: toAddress,
      satoshiToSend: amount.toInt(),
    );

    _broadcastTransaction(tx.toHex());
  }

  @override
  Future<Uint8List> signTransaction(
      {required String privateKey,
      required Map<String, dynamic> transactionParams}) {
    // TODO: implement signTransaction
    throw UnimplementedError();
  }

  @override
  Stream<TransactionEntity> watchAllTransactions() {
    // TODO: implement watchAllTransactions
    throw UnimplementedError();
  }

  Future<List<UTXO>> _getWalletUTXOs(String address) async {
    final rawUri = '$baseUri/address/$address/utxo';
    final Uri uri = Uri.parse(rawUri);

    final Response response = await get(uri);
    final rawUTXOs = jsonDecode(response.body) as List;

    return rawUTXOs
        .map((item) => UTXO(
              txHash: item['txid'],
              value: item['value'],
              vout: item['vout'],
            ))
        .toList();
  }

  int _estimateTxFeeFromWeight({
    required double satoshiPerVb,
    required int txWeight,
  }) {
    const int p2wpkhWeightDenominator = 4;
    return (txWeight / p2wpkhWeightDenominator * satoshiPerVb).ceil();
  }

  Future<List<FeeRate>> _getTransactionFeeRates() async {
    final String rawUri = '$baseUri/fee-estimates';
    final Uri uri = Uri.parse(rawUri);

    final Response response = await get(uri);
    final Map data = jsonDecode(response.body);

    return data.entries
        .map((MapEntry e) => FeeRate(
              blockNumber: int.parse(e.key),
              satoshiPerVb: e.value,
            ))
        .toList()
      ..sort((FeeRate a, FeeRate b) => a.blockNumber.compareTo(b.blockNumber));
  }

  Future<Transaction> _createTransaction({
    required String fromBech32,
    required String fromPublic,
    required String fromPrivate,
    required String toBech32,
    required int satoshiToSend,
  }) async {
    final List<UTXO> utxos = await _getWalletUTXOs(fromBech32);

    final int totalBalance = utxos.fold(0, (a, b) => a + b.value);
    if (totalBalance < satoshiToSend) {
      throw ArgumentError('Not enough balance');
    }

    final int fee = (await estimateTransactionFee(
      fromBech32,
      toBech32,
      satoshiToSend.toDouble(),
    ))
        .toInt();

    final int satoshiToReturn = totalBalance - satoshiToSend - fee;
    if (satoshiToReturn < 0) {
      throw ArgumentError('Not enough balance to pay transation fee');
    }

    final script = P2WPKH(
      data: PaymentData(pubkey: hexToBytes(fromPublic)),
      network: network,
    );

    final builder = TransactionBuilder(network: network);
    for (final UTXO utxo in utxos) {
      builder.addInput(
        utxo.txHash,
        utxo.vout,
        null,
        script.data.output,
      );
    }

    builder.setVersion(2);
    builder.addOutput(toBech32, satoshiToSend);
    builder.addOutput(fromBech32, satoshiToReturn);

    final ECPair fromPair = ECPair.fromPrivateKey(
      hexToBytes(fromPrivate),
      network: network,
    );

    for (int i = 0; i < builder.inputs.length; ++i) {
      builder.sign(vin: i, keyPair: fromPair, witnessValue: utxos[i].value);
    }

    return builder.build();
  }

  Future<String> _broadcastTransaction(String txHex) async {
    final String rawUri = '$baseUri/tx';
    final Uri uri = Uri.parse(rawUri);

    final Response response = await post(uri, body: txHex);

    if (response.statusCode != 200) {
      throw ArgumentError('Transaction was rejected');
    }

    return response.body;
  }
}

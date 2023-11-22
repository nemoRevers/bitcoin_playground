import 'dart:io';
import 'dart:typed_data';

import 'package:bitcoin_playground/transaction_entity.dart';
import 'package:bitcoin_playground/web3client_provider.dart';
import 'package:path/path.dart';
import 'package:web3dart/web3dart.dart';

class ERC20ClientProvider implements Web3ClientProvider {
  final Web3Client _web3client;
  late final String _abiCode;
  late final DeployedContract _contract;

  ERC20ClientProvider(
    Web3Client web3client,
    String contractAddress,
  ) : _web3client = web3client {
    final File abiFile =
        File(join(dirname(Platform.script.path), 'erc/erc20.abi.json'));
    _abiCode = abiFile.readAsStringSync();
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, 'contract'),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  @override
  Future<double> estimateTransactionFee(String from, String to, double amount) {
    // TODO: implement estimateTransactionFee
    throw UnimplementedError();
  }

  @override
  Future<int> getBalance(String address) async {
    final EthereumAddress ethAddress = EthereumAddress.fromHex(address);
    final balanceFunction = _contract.function('balanceOf');
    final BigInt balance = (await _web3client.call(
      contract: _contract,
      function: balanceFunction,
      params: [ethAddress],
    ))
        .first;
    return balance.toInt();
  }

  @override
  Future<void> sendTransaction({
    required String privateKey,
    required String toAddress,
    required double amount,
  }) async {
    final sendFunction = _contract.function('transfer');
    await _web3client.sendTransaction(
      EthPrivateKey.fromHex(privateKey),
      Transaction.callContract(
        contract: _contract,
        gasPrice: await _web3client.getGasPrice(),
        function: sendFunction,
        parameters: [
          EthereumAddress.fromHex(toAddress),

          ///TODO:converter
          BigInt.from(amount.toInt()),
        ],
      ),
      chainId: (await _web3client.getChainId()).toInt(),
    );
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
}

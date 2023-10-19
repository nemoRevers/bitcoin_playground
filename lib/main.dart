import 'package:bitcoin_playground/bitcoin_client_provider_impl.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

import 'bitcoin_key_generator_repository_impl.dart';

enum Coins {
  bitcoin,
}

void main() async {
  final provider = BitcoinClientProviderImpl.testnet();
  final keyGeneratorRepository = BitcoinKeyGeneratorRepositoryImpl(bitcoin);

  final mnemonic =
      "give dream rain oppose board replace panda view cake reveal foil cousin";
  // final mnemonic = generateMnemonic();
  print(mnemonic);
  final privateKey = await keyGeneratorRepository.getPrivateKey(mnemonic);
  print(privateKey);
  final publicKey = keyGeneratorRepository.getPublicKey(privateKey);
  print(publicKey);
  final address = keyGeneratorRepository.getAddress(publicKey);
  print(address);

  print(
      await provider.getBalance("tb1qn636fpfxujad0am9mgwvmnz6d0w2a8rczj2tht"));
  // provider.sendTransaction(
  //     privateKey: privateKey, toAddress: toAddress, amount: 10000);
}

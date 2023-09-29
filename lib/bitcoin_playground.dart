import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

void main() async {
  final mnemonic = generateMnemonic(strength: 256);
  print(mnemonic);
  final seed = mnemonicToSeed(mnemonic);
  final index = 0;
  final address = await generateReceivingAddress(seed, index);
  print(address);
}

Future<String?> generateReceivingAddress(Uint8List seed, int index) async {
  final wallet = HDWallet.fromSeed(seed, network: testnet)
      .derivePath("m/84'/1'/0'/0/$index");
  print(wallet.pubKey);
  print(wallet.privKey);
  final address = P2WPKH(
    data: PaymentData(pubkey: utf8.encode(wallet.pubKey!) as Uint8List),
    network: wallet.network,
  ).data.address;
  return address;
}

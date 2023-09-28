import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

void main() async {
  final mnemonic = generateMnemonic();
  final seed = mnemonicToSeed(mnemonic);
  final index = 0;
  final address = await generateReceivingAddress(seed, index);
  print(address);
}

Future<String?> generateReceivingAddress(Uint8List seed, int index) async {
  final wallet = HDWallet.fromSeed(seed).derivePath("m/49'/0'/0'/0/$index");
  print(wallet.pubKey);
  print(wallet.privKey);
  final address = P2WPKH(
          data: PaymentData(pubkey: utf8.encode(wallet.pubKey!) as Uint8List))
      .data
      .address;
  return address;
}

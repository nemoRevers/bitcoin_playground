import 'dart:typed_data';

import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

void main() async {
  final mnemonic = generateMnemonic();
  print(mnemonic);
  final seed = mnemonicToSeed(mnemonic);
  final index = 0;
  final address = await generateReceivingAddress(seed, index);
  print(address);
  // print(wallet.pubKey);
  // print(wallet.privKey);
  // print(wallet.wif);
}

Future<String?> generateReceivingAddress(Uint8List seed, int index) async {
  final root = BIP32.fromSeed(seed);
  final node = root.derivePath("m/49'/0'/0'/0/$index");

  final address =
      P2WPKH(data: PaymentData(pubkey: node.publicKey)).data.address;
  return address;
}

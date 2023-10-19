import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:web3dart/crypto.dart';

import 'key_constants.dart';
import 'mnemonic_repository_impl.dart';

class BitcoinKeyGeneratorRepositoryImpl extends MnemonicRepositoryImpl {
  final NetworkType _network;

  BitcoinKeyGeneratorRepositoryImpl(NetworkType networkType)
      : _network = networkType;

  Future<String> getPrivateKey(String mnemonic) async {
    final String derivationPath = _network == bitcoin
        ? KeyConstants.bitcoinDerivationPath
        : KeyConstants.testnetDerivationPath;
    print(derivationPath);
    final HDWallet wallet = HDWallet.fromSeed(bip39.mnemonicToSeed(mnemonic))
        .derivePath(derivationPath)
        .derive(1);
    return wallet.privKey!;
  }

  String getAddress(String publicKey) {
    final ECPair pair = ECPair.fromPublicKey(hexToBytes(publicKey));

    final P2WPKH a = P2WPKH(
      data: PaymentData(pubkey: pair.publicKey),
      network: _network,
    );

    return a.data.address!;
  }

  String getPublicKey(String privateKey) {
    final ECPair pair = ECPair.fromPrivateKey(
      hexToBytes(privateKey),
      network: _network,
    );
    return bytesToHex(pair.publicKey);
  }
}

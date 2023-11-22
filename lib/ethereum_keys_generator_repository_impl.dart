import 'package:bip39/bip39.dart' as bip39;
import 'package:bitcoin_playground/mnemonic_repository_impl.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'key_generator_repository.dart';

class EthereumKeyGeneratorRepositoryImpl extends MnemonicRepositoryImpl
    implements KeyGeneratorRepository {
  @override
  Future<String> getPrivateKey(String mnemonic) async {
    final String seed = bip39.mnemonicToSeedHex(mnemonic);
    final KeyData master =
        await ED25519_HD_KEY.getMasterKeyFromSeed(HEX.decode(seed));
    final String privateKey = bytesToHex(master.key, include0x: true);
    return privateKey;
  }

  @override
  String getAddress(String privateKey) {
    final EthPrivateKey private = EthPrivateKey.fromHex(privateKey);
    final EthereumAddress address = private.address;
    return address.toString();
  }

  @override
  String getPublicKey(String privateKey) {
    final EthPrivateKey ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    return ethPrivateKey.publicKey.toString();
  }
}

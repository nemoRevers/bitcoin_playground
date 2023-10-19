import 'package:bip39/bip39.dart' as bip39;

class MnemonicRepositoryImpl {
  String? _mnemonic;

  String? get mnemonic => _mnemonic;

  String generateMnemonic() {
    final String mnemonic = bip39.generateMnemonic();
    _mnemonic = mnemonic;
    return mnemonic;
  }

  bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }
}

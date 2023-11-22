abstract class KeyGeneratorRepository {
  const KeyGeneratorRepository();

  String? get mnemonic;

  String generateMnemonic();

  Future<String> getPrivateKey(String mnemonic);

  String getAddress(String privateKey);

  String getPublicKey(String privateKey);

  bool validateMnemonic(String mnemonic);
}

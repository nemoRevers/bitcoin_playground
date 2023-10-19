class UTXO {
  final String txHash;
  final int value;
  final int vout;

  const UTXO({
    required this.txHash,
    required this.value,
    required this.vout,
  });

  @override
  String toString() {
    return 'txHash: $txHash, value: $value, vout: $vout';
  }
}

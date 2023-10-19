class TransactionInfo {
  final String hash;
  final String fromBech32;
  final String toBech32;
  final int sentSatoshi;
  final int feeSatoshi;
  final bool isConfirmed;

  const TransactionInfo({
    required this.hash,
    required this.fromBech32,
    required this.toBech32,
    required this.sentSatoshi,
    required this.feeSatoshi,
    required this.isConfirmed,
  });
}

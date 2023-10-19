enum Tokens {
  bitcoin('Bitcoin', 'BTC'),
  ethereum('Ethereum', 'ETH'),
  litecoin('Litecoin', 'LTC'),
  neo('Neo', 'NEO'),
  steller('Steller', 'XLM');

  final String assetName;
  final String assetAbbreviation;

  const Tokens(
    this.assetName,
    this.assetAbbreviation,
  );
}

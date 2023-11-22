import 'package:bitcoin_playground/erc/ERC20_client_provider_impl.dart';
import 'package:bitcoin_playground/web3client_provider.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const String rpcUrl = 'http://127.0.0.1:7545';

void main() async {
  final client = Web3Client(rpcUrl, Client());
  final Web3ClientProvider provider = ERC20ClientProvider(
    client,
    '0x83e68b0Aef257b5d9DBB266bFF71e10BEfbDd39a',
  );
  // final Erc20 erc20 = Erc20(
  //     address:
  //         EthereumAddress.fromHex('0x83e68b0Aef257b5d9DBB266bFF71e10BEfbDd39a'),
  //     client: client);
  // final String mnemonic =
  //     "envelope slot deal sample bread planet explain chimney burst window bench host";
  // final KeyGeneratorRepository keyGeneratorRepository =
  //     EthereumKeyGeneratorRepositoryImpl();
  // final prv = await keyGeneratorRepository.getPrivateKey(mnemonic);
  // final addressString = keyGeneratorRepository.getAddress(prv);
  // final EthereumAddress address =
  //     EthereumAddress.fromHex('0x1D0A6e329d191852e97157C1006Ae8f9b4B09D97');

  // final File abiFile =
  //     File(join(dirname(Platform.script.path), 'erc/erc20.abi.json'));
  // final String abiCode = await abiFile.readAsString();
  // final DeployedContract contract = DeployedContract(
  //   ContractAbi.fromJson(abiCode, ''),
  //   EthereumAddress.fromHex('0x83e68b0Aef257b5d9DBB266bFF71e10BEfbDd39a'),
  // );
  var balance = await provider.getBalance(
    "0x1D0A6e329d191852e97157C1006Ae8f9b4B09D97",
  );
  print(balance);
  await provider.sendTransaction(
    privateKey:
        "0x7ef16a3008a57f6326ca602010601a70abe2da7a08fb9c8462b43137efaa327e",
    toAddress: "0x1D0A6e329d191852e97157C1006Ae8f9b4B09D97",
    amount: 100000000,
  );

  balance = await provider.getBalance(
    "0x1D0A6e329d191852e97157C1006Ae8f9b4B09D97",
  );
  print(balance);
}

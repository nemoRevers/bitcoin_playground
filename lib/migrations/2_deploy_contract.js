const MyToken = artifacts.require("MyToken");

module.exports = async function (deployer, network, accounts) {
  deployer.deploy(MyToken,"MyToken", "MTKN", accounts[2],900000000000000);
};

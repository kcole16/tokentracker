var FixedSupplyToken = artifacts.require("./FixedSupplyToken.sol");
var Watchman = artifacts.require("./Watchman.sol");

module.exports = function(deployer) {
  deployer.deploy(FixedSupplyToken);
  deployer.deploy(Watchman);
};

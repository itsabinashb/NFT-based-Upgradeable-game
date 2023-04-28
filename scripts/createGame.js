const { ethers } = require("hardhat");
const { upgrades } = require("@openzeppelin/hardhat-upgrades");

async function main() {
	const Game = await ethers.getContractAt("Game");
	const game = Game.attach("0xc79F6DbB9FfAEC3f28eDEACB1Fe921f3c9B3eC25");
	const upgradedgame = await upgrades.upgradeProxy(game.address, Game);
	console.log(`Upgraded!`);
	const owner = await upgradedgame.owner();
	console.log(`owner is:`, owner);
}
main();

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

// imports
import {Test, console} from "forge-std/Test.sol";
import {LibraryNFT} from "../src/LibraryNFT.sol";
import {DeployLibraryNFT} from "../script/DeployLibraryNFT.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract TestLibraryNFT is Test {
    LibraryNFT public libraryNFT;
    DeployLibraryNFT public deployer;
    address public USER = makeAddr("user");

    function setUp() external {
        deployer = new DeployLibraryNFT();
        libraryNFT = deployer.run();
    }

    //testCorrectImagePath
    function testviewtokenURI() external {
        //Arrange
        vm.prank(USER);
        //Act
        libraryNFT.mintNFT(USER, "georgefalcon");
        console.log(
            libraryNFT.tokenURI(
                1,
                "georgefalcon",
                "MEE_2019_111",
                "Technology",
                "Mechanical Engineering"
            )
        );
    }
}

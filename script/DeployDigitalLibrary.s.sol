// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

// imports
import {Script, console} from "forge-std/Script.sol";
import {DigitalLibrary} from "../src/DigitalLibrary.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DeployDigitalLibrary is Script {
    DigitalLibrary public digitalLibrary;

    function run() external returns (DigitalLibrary) {
        vm.startBroadcast();
        digitalLibrary = new DigitalLibrary();
        vm.stopBroadcast();
        return digitalLibrary;
    }
}

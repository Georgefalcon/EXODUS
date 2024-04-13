// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

// imports
import {Test, console} from "forge-std/Test.sol";
import {DigitalLibrary} from "../src/DigitalLibrary.sol";
import {DeployDigitalLibrary} from "../script/DeployDigitalLibrary.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {LibraryNFT} from "../src/LibraryNFT.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract TestDigitalLibrary is Test {
    DigitalLibrary public digitalLibrary;
    DeployDigitalLibrary public deployer;
    LibraryNFT public libraryNFT;
    address public USER1 = makeAddr("user1");
    address public USER2 = makeAddr("user2");

    function setUp() external {
        deployer = new DeployDigitalLibrary();
        digitalLibrary = deployer.run();
    }

    modifier Registers() {
        //Arrange
        vm.prank(USER1);

        //Act

        // Register first student
        digitalLibrary.registerNewStudent(
            "George",
            "Falcon",
            "MEE_2019_111",
            "Technology",
            "Mechanical Engineering",
            USER1
        );
        (string memory Name, , , , , address WalletAddress, ) = digitalLibrary
            .getStudent(USER1);
        _;
    }

    // Test Student Registration
    function testStudentRegistration() external {
        //Arrange
        vm.prank(USER1);

        //Act

        // Register first student
        digitalLibrary.registerNewStudent(
            "George",
            "Falcon",
            "MEE_2019_111",
            "Technology",
            "Mechanical Engineering",
            USER1
        );
        (string memory Name, , , , , address WalletAddress, ) = digitalLibrary
            .getStudent(USER1);

        //Assert

        // Verify registration
        assert(WalletAddress == USER1);
        assert(
            keccak256(abi.encodePacked(Name)) ==
                keccak256(abi.encodePacked("George"))
        );

        // Register Sceond student
        //Arrange
        vm.prank(USER2);

        //Act
        digitalLibrary.registerNewStudent(
            "Alison",
            "Fish",
            "BCH_2019_112",
            "science",
            "Biochemistry",
            USER2
        );
        (string memory name, , , , , address walletAddress, ) = digitalLibrary
            .getStudent(USER2);

        // Verify registration
        assert(walletAddress == USER2);
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked("Alison"))
        );
    }

    // Internal function to mimic the behavior of assignImageToNFT() in DigitalLibrary contract
    function assignImageToNFT(
        DigitalLibrary _library
    ) internal returns (string memory) {
        uint256 totalImages = 6; // Adjstable
        uint256 _nextImageIndex = 0; // Variable to store the index of the next image to be assigned
        // Calculate the index of the image to be assigned based on the nextImageIndex
        uint256 imageIndex = _nextImageIndex % totalImages;

        // Construct the file path of the selected image
        string memory imagePath = string(
            abi.encodePacked("img/image", Strings.toString(imageIndex), ".svg")
        );
        // Increment the nextImageIndex for the next assignment
        _nextImageIndex = (_nextImageIndex + 1) % totalImages;

        return imagePath;
    }

    function testAssignImageToNFT() external Registers {
        // Verify the image paths for the first student
        for (uint256 i = 0; i < 3; i++) {
            string memory imagePath = assignImageToNFT(digitalLibrary);
        }
    }
}

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

/**
 * @title A Digital Book Shelf
 * @author The MATRIX
 * @notice This contract is for creating funds for a particular campaign
 * @dev Implements.....
 */

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts

// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

//imports
import {Script, console} from "forge-std/Script.sol";
import {LibraryNFT} from "../src/LibraryNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DigitalLibrary is Script {
    // errors
    error DigitalLibrary__StudentWalletAddressAleardyExist();
    error DigitalLibrary__NotOwner();
    error DigitalLibrary__MatricNoExist();

    //State Variables
    uint256 private StudentCounter;
    address private owner;
    uint256 private _nextImageIndex = 0; // Variable to store the index of the next image to be assigned
    LibraryNFT public libraryNFT;
    mapping(address => Student) public students;
    mapping(address => uint256) public mintedNFTsCount; // Number of NFTs minted for each student
    mapping(string => address) public MatricToaddress;

    // Struct to store student data
    struct Student {
        string Name;
        string Surname;
        string MatricNumber;
        string Falculty;
        string Department;
        address WalletAddress;
        uint256[] NftCards; // IDS of Nft owned by student
        uint256 tokenBalance;
    }

    // Events
    //Event to emit when a student is registered
    event StudentRegistered(
        string indexed _matricNumber,
        address indexed _walletAddress
    );
    // Optional: Define events to log NFT minting process and send notifications
    event NFTMintedForStudent(address indexed student, uint256 tokenId);
    event NFTSentNotification(address indexed student, uint256 tokenId);

    constructor() {
        StudentCounter = 0;
    }

    modifier onlyOwner() {
        if (owner != msg.sender) {
            revert DigitalLibrary__NotOwner();
        }
        _;
    }

    // Function to register a new student
    function registerNewStudent(
        string memory _name,
        string memory _surname,
        string memory _matricNumber,
        string memory _faculty,
        string memory _department,
        address _WalletAddress
    ) public {
        // Check if the student is already registered
        // Check if student is already registered with this wallet address
        if (
            students[msg.sender].WalletAddress != address(0) &&
            students[msg.sender].WalletAddress == _WalletAddress
        ) {
            revert DigitalLibrary__StudentWalletAddressAleardyExist();
        }
        if (MatricToaddress[_matricNumber] == msg.sender) {
            revert DigitalLibrary__MatricNoExist();
        }
        MatricToaddress[_matricNumber] = msg.sender;
        // create a new student object
        Student storage newStudent = students[msg.sender];
        newStudent.Name = _name;
        newStudent.Surname = _surname;
        newStudent.MatricNumber = _matricNumber;
        newStudent.Falculty = _faculty;
        newStudent.Department = _department;
        newStudent.WalletAddress = msg.sender;
        // Increament of studentCount
        StudentCounter++;
        // Emit an event
        emit StudentRegistered(_matricNumber, msg.sender);
        // Automatically mint NFTs for the registered student
        sendNFTsToStudent(msg.sender, _name);
    }

    function sendNFTsToStudent(address _student, string memory _name) internal {
        uint256 totalImages = 6;

        // Calculate the starting image index for the student
        uint256 startIndex = (_nextImageIndex) % totalImages;

        // Mint three NFTs for the student
        for (uint256 i = 0; i < 3; i++) {
            // Calculate the image index based on the student's starting index
            uint256 imageIndex = (startIndex + i) % totalImages;

            // Construct the file path of the selected image
            string memory imagePath = string(
                abi.encodePacked(
                    "img/image",
                    Strings.toString(imageIndex),
                    ".svg"
                )
            );

            // Log the selected image path for the student
            console.log("Image path for Student", _name, ":", imagePath);

            // Create an instance of the LibraryNFT contract
            libraryNFT = new LibraryNFT(svgToImageURI(vm.readFile(imagePath)));

            // Mint NFT and get the token ID
            uint256 tokenId = libraryNFT.mintNFT(_student, _name);
            tokenId = StudentCounter;

            // Update the tokenId to ensure uniqueness
            StudentCounter++;
            mintedNFTsCount[_student]++;

            // Log the NFT minting process using events
            emit NFTMintedForStudent(_student, tokenId);

            // Send a notification to the student
            emit NFTSentNotification(_student, tokenId);
        }

        // Update _nextImageIndex after minting NFTs
        _nextImageIndex = (_nextImageIndex + 3) % totalImages;

        // Log the updated value of _nextImageIndex after incrementing
        console.log("After increment: _nextImageIndex =", _nextImageIndex);
    }

    // Function to assign an image to an NFT based on student registration count
    function assignImageToNFT() internal returns (string memory) {
        uint256 totalImages = 6;
        // Calculate the index of the image to be assigned based on the nextImageIndex
        uint256 imageIndex = _nextImageIndex % totalImages;

        // Construct the file path of the selected image
        string memory imagePath = string(
            abi.encodePacked("img/image", Strings.toString(imageIndex), ".svg")
        );

        // Increment the nextImageIndex for the next assignment
        _nextImageIndex++;

        return imagePath;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgbase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgbase64Encoded));
    }

    ////////////////
    ////GETTERS////
    //////////////
    function getStudent(
        address studentAddress
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            address,
            uint256
        )
    {
        return (
            students[studentAddress].Name,
            students[studentAddress].Surname,
            students[studentAddress].MatricNumber,
            students[studentAddress].Falculty,
            students[studentAddress].Department,
            students[studentAddress].WalletAddress,
            students[studentAddress].tokenBalance
        );
    }
}

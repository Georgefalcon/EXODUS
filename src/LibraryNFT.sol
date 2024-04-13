// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

/**
 * @title A Digital Book Shelf
 * @author The MATRIX
 * @notice This contract is for NFT generation to be distributed to students
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

// imports
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract LibraryNFT is ERC721 {
    //State Variables
    uint256 private _tokenCounter; // Counter for generating unique token IDs
    string private _SvgToImageURI;
    uint256 private _nextImageIndex; // Variable to store the index of the next image to be assigned
    string private _imageURI;

    constructor(
        string memory svgToImageURI
    ) ERC721("Decentralized Library", "DEL") {
        _tokenCounter = 0;
        _nextImageIndex = 0;
        _SvgToImageURI = svgToImageURI;
    }

    /////////////////////
    //////SETTER////////
    ////////////////////

    function TokenName(uint256 tokenId, string memory uniqueName) public view {}

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

    // Internal function to mint the NFT with the given metadata
    function _mintNFT(
        address recipient,
        string memory uniqueName,
        string memory imageURI
    ) internal returns (uint256) {
        _tokenCounter++;
        imageURI = _SvgToImageURI;
        _safeMint(recipient, _tokenCounter);
        // _setTokenURI(newTokenId, imageURI); // Set token URI to image URI for simplicity
        TokenName(_tokenCounter, uniqueName); // Set token name

        return _tokenCounter;
    }

    // Function to mint NFT to student

    function mintNFT(
        address recipient,
        string memory _studentName // This were parameters for this function
    ) external returns (uint256) {
        // Generate a unique name for the NFT based on the student's name
        // Generate a unique name for the NFT based on the student's name and a serial number
        string memory uniqueName = string(
            abi.encodePacked(
                _studentName,
                "'s Library Card #",
                Strings.toString(_tokenCounter)
            )
        );

        // Assign image to NFT based on the order of student registrations
        string memory uniqueImagePath = assignImageToNFT();

        // Mint the NFT with the generated metadata
        uint256 tokenId = _mintNFT(recipient, uniqueName, uniqueImagePath);
        return tokenId;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId,
        string memory _studentName,
        string memory _matricNumber,
        string memory _faculty,
        string memory _department
    ) public view returns (string memory) {
        string memory description = "An NFT representing a library card.";
        string memory uniqueName = string(
            abi.encodePacked(
                _studentName,
                "'s Library Card #",
                Strings.toString(tokenId)
            )
        );
        string memory attributes = string(
            abi.encodePacked(
                '{"trait_type": "Matric Number", "value": "',
                _matricNumber,
                '"}, ',
                '{"trait_type": "Faculty", "value": "',
                _faculty,
                '"}, ',
                '{"trait_type": "Department", "value": "',
                _department,
                '"}'
            )
        );
        string memory imageURI = _SvgToImageURI; // Replace this with the actual image URI logic

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                uniqueName,
                                '", "description":"',
                                description,
                                '", "attributes": [',
                                attributes,
                                '], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}

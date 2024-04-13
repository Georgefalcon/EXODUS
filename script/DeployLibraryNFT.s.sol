// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.22;

// imports
import {Script, console} from "forge-std/Script.sol";
import {LibraryNFT} from "../src/LibraryNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DeployLibraryNFT is Script {
    LibraryNFT public libraryNFT;
    uint256 private _nextImageIndex = 0; // Variable to store the index of the next image to be assigned

    function run() external returns (LibraryNFT) {
        vm.startBroadcast();
        string memory ImagePath = assignImageToNFT();
        string memory Imagesvg = vm.readFile(ImagePath);
        libraryNFT = new LibraryNFT(svgToImageURI(Imagesvg));
        vm.stopBroadcast();
        return libraryNFT;
    }

    // Function to assign an image to an NFT based on student registration count
    function assignImageToNFT() internal returns (string memory) {
        uint256 totalImages = 4;
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
}

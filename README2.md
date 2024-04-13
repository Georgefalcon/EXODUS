// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LibrarySystem {
    // Struct to represent a student
    struct Student {
        uint256 id;
        address walletAddress;
        uint256[] nftCards; // IDs of NFT cards owned by the student
        uint256 tokenBalance;
    }

    // Mapping to store student data
    mapping(address => Student) public students;

    // 
    
    event StudentRegistered(uint256 studentId, address walletAddress);

    // Function to register a new student
    function registerStudent(uint256 _studentId) external {
    // Check if the student is already registered
    require(students[msg.sender].WalletAddress == address(0)"Student already registered")

        // Create a new student object
        Student storage newStudent = students[msg.sender];
        newStudent.id = _studentId;
        newStudent.walletAddress = msg.sender;

        // Emit an event
        emit StudentRegistered(_studentId, msg.sender);
    }
}

/////////////////////
//////LIBRARY NFT/////
/////////////////////

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LibraryNFT is ERC721 {
    uint256 public nextTokenId;

    constructor() ERC721("LibraryCard", "LCARD") {}

    function mintNFT(address recipient) external returns (uint256) {
        uint256 newTokenId = nextTokenId;
        _safeMint(recipient, newTokenId);
        nextTokenId++;
        return newTokenId;
    }
}

OR

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract LibraryNFT is ERC721 {
    // Constant description for all NFTs
    string constant DESCRIPTION = "Library card for borrowing books from the school library";

    constructor() ERC721("LibraryCard", "LCARD") {}

    // Function to mint NFTs for students
    function mintNFT(address recipient, string memory studentName, string memory matricNumber, string memory department, string memory faculty) external returns (uint256) {
        // Generate a unique name for the NFT based on the student's name
        uint256 private nextTokenId = 1; // Counter for generating unique token IDs

    // Generate a unique name for the NFT based on the student's name and a serial number
    string memory uniqueName = string(abi.encodePacked(studentName, "'s Library Card #", Strings.toString(nextTokenId)));

    // Increment the token ID counter for the next NFT
    nextTokenId++;

    // Other code remains unchanged...
}

        
    // Assign image to NFT based on the order of student registrations
    string memory uniqueImageURI = assignImageToNFT();

        // Mint the NFT with the generated metadata
        uint256 tokenId = _mintNFT(recipient, uniqueName, uniqueImageURI);

        return tokenId;
    }


    // Internal function to mint the NFT with the given metadata
    function _mintNFT(address recipient, string memory name, string memory imageURI) internal returns (uint256) {
        uint256 newTokenId = totalSupply() + 1;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, imageURI); // Set token URI to image URI for simplicity
        _setTokenName(newTokenId, name); // Set token name
        return newTokenId;
    }

    // Generate a unique image URI based on the student's information
    function generateImageURI(string memory matricNumber, string memory department, string memory faculty) internal pure returns (string memory) {
        // Here, you can generate a unique image URL using the student's information
        // For example, you can concatenate the student's matric number, department, and faculty
        // to form a unique image URL
        // Ensure that the generated URL points to an actual image file accessible by the contract
        string memory imageUrl = string(abi.encodePacked("https://example.com/", matricNumber, "/", department, "/", faculty, ".png"));
        return imageUrl;
    }
}


/////////////////////
//////IMAGE ASSIGNER/////
/////////////////////
import "hardhat/console.sol"; // Import console for debugging purposes

contract LibraryNFT is ERC721 {
    // Other contract code...
    import{String} from openzeppelin

    // Variable to store the index of the next image to be assigned
    uint256 private nextImageIndex = 0;

    // Function to assign an image to an NFT based on student registration count
    function assignImageToNFT() internal returns (string memory) {
        // Calculate the index of the image to be assigned based on the nextImageIndex
        uint256 imageIndex = nextImageIndex % totalImages;

        // Construct the file path of the selected image
        string memory imagePath = string(abi.encodePacked("img/image", Strings.toString(imageIndex), ".jpg"));

        // Increment the nextImageIndex for the next assignment
        nextImageIndex++;

        return imagePath;
    }
}



/////////////////////
//////DEPLOY SCRIPT/////
/////////////////////

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgbase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(imagePath)))
        );
        return string(abi.encodePacked(baseURL, svgbase64Encoded));


/////////////////////
//////LIBRARY TOKEN/////
/////////////////////

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LibraryToken is ERC20 {z`
    constructor() ERC20("LibraryToken", "LTOKEN") {}

    function mintTokens(address recipient, uint256 amount) external {
        _mint(recipient, amount);
    }
}


/////////////////////
//////MINTING/////
/////////////////////
Automatically send student three NFT on registering
contract LibrarySystem {
    LibraryNFT public nftContract;
    mapping(address => bool) public registeredStudents;
    mapping(address => uint256) public mintedNFTsCount; // Number of NFTs minted for each student
    address public owner; // Contract owner address

    constructor(address _nftContractAddress) {
        nftContract = LibraryNFT(_nftContractAddress);
        owner = msg.sender; // Set the contract owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function registerStudent() external {
        require(!registeredStudents[msg.sender], "Student already registered");

        // Mark the student as registered
        registeredStudents[msg.sender] = true;

        // Automatically mint NFTs for the registered student
        sendNFTsToStudent(msg.sender);
    }

    function sendNFTsToStudent(address _student) internal onlyOwner {
        require(registeredStudents[_student], "Student not registered");
        require(mintedNFTsCount[_student] < 3, "Student has already received 3 NFTs");

        // Mint three NFT cards for the student
        for (uint256 i = mintedNFTsCount[_student]; i < 3; i++) {
            uint256 tokenId = nftContract.mintNFT(_student);
            mintedNFTsCount[_student]++;
            
            // Log the NFT minting process using events
            emit NFTMintedForStudent(_student, tokenId);

            // Send a notification to the student
            emit NFTSentNotification(_student, tokenId);
        }
    }

    // Optional: Define events to log NFT minting process and send notifications
    event NFTMintedForStudent(address indexed student, uint256 tokenId);
    event NFTSentNotification(address indexed student, uint256 tokenId);
}

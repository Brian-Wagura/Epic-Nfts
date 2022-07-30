// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// Import some OpenZeppelin Contracts.
// Some util functions for strings
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";


// We'll have access to the inherited contract's methods.

contract MyEpicNFT is ERC721URIStorage {

    //Helps us keep track of token IDs
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Our SVG code
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo="' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
    string[] firstWords = ["Chicken", "Hamburger", "Hotdog", "Pizza", "Chips", "MilkShake","IceCream","Nachos","Popcorn","Juice","Sodas","Fillet","Burrito","Taco","Sandwich"];
    string[] secondWords = ["Vienna", "Rome", "Lisbon", "Nairobi", "Madrid", "London","Havana","Mexico","Beijing","Tokyo","AbuDhabi","Cairo","Winhoek","FreeTown","Kampala"];
    string[] thirdWords = ["JustinBeiber","KatyPerry","BrunoMars","AliciaKeys","ChrisBrown","Rihanna","Shakira","WizKhalifa","Ludacris","SnoopDogg","Usher","DavidGuetta","TreySongz","Beyonce","ColdPlay"];

    string[] colors = ["red","#08c2a8","brown","magenta","yellow","blue","green","gray"];

    event NewEpicNFTMinted(address sender , uint256 tokenId);

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah! This is awesome! Created by Wagura Brian.");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }
  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));


    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor,svgPartTwo ,combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );



    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    
    _setTokenURI(newItemId,finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT with ID %s has been minted to %s", newItemId, msg.sender);

    // emit magical events
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}





    

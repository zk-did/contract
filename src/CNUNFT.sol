// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Groth16Verifier.sol";

contract CNUNFT is ERC721URIStorage, Ownable {
    Groth16Verifier public verifier;
    uint256 public nextTokenId = 1;

    // 이미 발급받았는지 체크하는 매핑
    mapping(address => bool) public hasMinted;

    event NFTMinted(address indexed recipient, uint256 tokenId);

    // 수정된 생성자, Ownable의 생성자에 msg.sender 전달
    constructor(address _verifierAddress) ERC721("CNU NFT", "CNU") Ownable(msg.sender) {
        verifier = Groth16Verifier(_verifierAddress);
    }

    // NFT 발급 함수 (zk-SNARK 프루프 검증을 통과해야 발급 가능)
    function mintNFT(
        uint[2] calldata _pA, 
        uint[2][2] calldata _pB, 
        uint[2] calldata _pC, 
        uint[5] calldata _pubSignals, 
        string memory tokenURI
    ) public {
        require(!hasMinted[msg.sender], "NFT already minted");

        // zk-SNARK proof 검증
        require(verifier.verifyProof(_pA, _pB, _pC, _pubSignals), "Invalid proof");

        // NFT 발급 및 메타데이터 설정
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);  // 메타데이터 URI 설정

        hasMinted[msg.sender] = true;
        nextTokenId++;

        emit NFTMinted(msg.sender, tokenId);
    }
}

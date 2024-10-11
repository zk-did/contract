// File: script/DeployCNUNFT.s.sol
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/CNUNFT.sol";
import "../src/Groth16Verifier.sol";

contract DeployCNUNFT is Script {
    function run() external {
        // 설정된 지갑을 사용하여 배포 시작
        vm.startBroadcast();

        // Groth16Verifier 컨트랙트 배포
        Groth16Verifier verifier = new Groth16Verifier();

        // CNUNFT 컨트랙트 배포, verifier 주소 전달
        CNUNFT nftContract = new CNUNFT(address(verifier));

        // 배포 완료 후 브로드캐스트 종료
        vm.stopBroadcast();

        console.log("CNUNFT deployed at:", address(nftContract));
        console.log("Groth16Verifier deployed at:", address(verifier));
    }
}

// SPDX-License-Identifier: MIT

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

pragma solidity ^0.8.14;


//author @jacmos3
contract TokenDispenser {
    address private _owner;
    uint256 public cost = 0.05 ether;
    uint256 public quantity = 11111 ether;
    address public tokenAddress = 0xB6CAE7E634b931404374fC236f94E701801E3423; //tripscommunity.com token
    bool public paused = true;
    IERC20 public token;
    event Sent(uint256 quantity);
    constructor() {
        _owner = msg.sender;
        token = IERC20(tokenAddress);
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function buyToken() external payable{
        require(!paused, "Contract paused");
        require(msg.value == cost, "Send more ETH, Sir");
        require(token.balanceOf(address(this)) >= quantity, "reservoir is dry");
        token.transfer(msg.sender,quantity);
        emit Sent(quantity);
    }

    function withdrawETH() external onlyOwner{
         payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw(address addr) external onlyOwner{
        IERC20(addr).transfer(msg.sender, token.balanceOf(address(this)));
    }

    function setTokenAddress(address addr) external onlyOwner{
        tokenAddress = addr;
        token = IERC20(tokenAddress);
    }

    function pauseUnpause() external onlyOwner{
        paused = !paused;
    }

    function setCostAndQuantity(uint256 _cost, uint256 _quantity) external onlyOwner{
        cost = _cost;
        quantity = _quantity;
    }
}

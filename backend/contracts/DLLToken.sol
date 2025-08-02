// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DLLToken is ERC20, Ownable {
    struct VestingSchedule {
        uint256 totalAmount;
        uint256 amountClaimed;
        uint256 start;
        uint256 cliff;
        uint256 duration;
    }

    mapping(address => VestingSchedule) public vestings;
    mapping(address => uint256) public stakes;

    event TokensStaked(address indexed staker, uint256 amount);
    event TokensUnstaked(address indexed staker, uint256 amount);

    constructor() ERC20("DaddyLongLegs Token", "DLL") {
        uint256 totalSupply = 1_000_000_000 * (10 ** decimals());
        _mint(msg.sender, totalSupply);

        uint256 teamVestingAmount = (totalSupply * 20) / 100;
        vestings[msg.sender] = VestingSchedule({
            totalAmount: teamVestingAmount,
            amountClaimed: 0,
            start: block.timestamp,
            cliff: 180 days,
            duration: 730 days
        });
    }

    function claimVestedTokens() external {
        VestingSchedule storage vesting = vestings[msg.sender];
        require(vesting.totalAmount > 0, "No vesting schedule");
        require(block.timestamp >= vesting.start + vesting.cliff, "Cliff not reached");

        uint256 vestedAmount = vestedAmountAt(block.timestamp, vesting);
        uint256 claimable = vestedAmount - vesting.amountClaimed;
        require(claimable > 0, "No tokens to claim");

        vesting.amountClaimed += claimable;
        _transfer(owner(), msg.sender, claimable);
    }

    function vestedAmountAt(uint256 timestamp, VestingSchedule memory vesting) public pure returns (uint256) {
        if (timestamp < vesting.start + vesting.cliff) {
            return 0;
        } else if (timestamp >= vesting.start + vesting.duration) {
            return vesting.totalAmount;
        } else {
            uint256 timeElapsed = timestamp - vesting.start;
            return (vesting.totalAmount * timeElapsed) / vesting.duration;
        }
    }

    function stake(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _transfer(msg.sender, address(this), amount);
        stakes[msg.sender] += amount;
        emit TokensStaked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient staked balance");
        stakes[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount);
        emit TokensUnstaked(msg.sender, amount);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}

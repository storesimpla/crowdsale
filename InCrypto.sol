pragma solidity ^0.4.19;

import "./Ownable.sol";
import "./ERC20.sol";

contract Crowdsale is Ownable {
    
    ERC20 public token;
    //
    string public constant name = "InCryptoToken";
    string public constant symbol = "ICT";
    uint8 public constant decimals = 18;
    
    //сколько всего выпущено токенов
    uint public constant TokensMinted = 10000 * (10 ** uint256(decimals));
    uint public constant MinimumSupply = 10;
    
    //курс для расчета стоимости токена 
    uint public rate;
    
    //состояние контракта продажа токенов (Running или Paused)
    string public SaleStatus;
    
    //сколько всего эфира отправили инвесторы на контракт
    uint public weiRaised = 0;
    
    function setRate(uint _rate) public onlyOwner {
        require(_rate>0);
        rate = _rate;
    }
    
    uint period = 14;
    uint StartTime = 1520640000;
    uint EndTime = StartTime + period*24*60*60;
    
    
    function() external payable {
        require(now > StartTime && now < EndTime);
        require(msg.value>MinimumSupply);
        require((weiRaised+msg.value)>0);
        owner.transfer(msg.value);
        BuyTokens(msg.sender);
    }
    
    function BuyTokens(address _to) public payable {
        require(_to != address(0));
        require(msg.value != 0);
        require((msg.value+weiRaised)>0);
        weiRaised += msg.value;
        
        uint tokens = rate*msg.value;
        require(tokens >= MinimumSupply);
        
        token.transfer(_to, tokens);
        
    }
    
    function IssueTokens(address _to, uint _value) public onlyOwner{
        token.transfer(_to, _value);
    }
    
    function StartCrowdSale() public onlyOwner{
        SaleStatus = "Running";
    }
    
    function PauseCrowdSale() public onlyOwner{
        SaleStatus = "Paused";
    }
    
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
 
/**
 * Math operations with safety checks
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface PriceOraclelInterface {
    function getThePrice(uint currIndex) external view returns (uint);
    function getFloorRate(uint floor) pure external returns(uint rate);
    function getLevelRate(address userAddress,uint teamBalance) pure external returns(uint levelRate);
}
contract RecordContract {
    
    struct FeeRecord{
        address user;
        uint8 currencyIndex;
        uint feeAmount;
        uint time;
    }

    struct TwoDepositAmount{
        //币种 2  的ID 
        uint8 id;
        uint libraAmount;
        uint amount2;
    }
    struct TwoTakeoutAmount{
        //币种 2  的ID 
        uint8 id;
        uint libraAmount;
        uint amount2;
    }

    struct OneTakeout{
        address userAddress;
        uint8 currencyIndex;
        uint takeoutAmount;
        uint feeAmount;
        uint takeoutTime;
    }

    struct TwoTakeout{
        address userAddress;
        uint8 currency1Index;
        uint takeoutAmount1;
        uint fee1Amount;
        uint8 currency2Index;
        uint takeoutAmount2;
        uint fee2Amount;
        uint takeoutTime;
    }

    struct TakeoutIncome{
        address user;
        uint amount;
        uint receivedAmount;
        uint takeoutTime;
    }

    struct DividendRecord{
        //1、持币分红  2、上级返利  3、感恩奖励  4、全球分红
        uint incomeType;
        address user;
        uint amount;
        uint time;
    }
    
    PriceOraclelInterface priceOracle;
    
    using SafeMath for uint;
    using SafeMath for uint8;

    uint8 constant libraId=1;
    uint8 constant btcId=2;
    uint8 constant ethId=3;
    uint8 constant usdtId=4;
    uint8 constant bnbId=5;
    uint8 constant filId=6;	
	uint8 constant adaId=7;
    uint8 constant xrpId=8;
    uint8 constant dogeId=9;
    uint8 constant dotId=10;
    uint8 constant solId=11;
    uint8 constant uniId=12;
    uint8 constant bchId=13;
    uint8 constant ltcId=14;
    uint8 constant linkId=15;
    uint8 constant eosId=16;
    uint8 constant diemId=17;
    
    
    uint public libraDestroyAmount;
    uint public btcFeeAmount;
    uint public ethFeeAmount;
    uint public usdtFeeAmount;
    uint public bnbFeeAmount;
    uint public filFeeAmount;
    uint public adaFeeAmount;
    uint public xrpFeeAmount;
    uint public dogeFeeAmount;
    uint public dotFeeAmount;
    uint public solFeeAmount;
    uint public uniFeeAmount;
    uint public bchFeeAmount;
    uint public ltcFeeAmount;
    uint public linkFeeAmount;
    uint public eosFeeAmount;
    uint public diemFeeAmount;
    
    uint public precision=0;
    
    uint public oneBtcTotalAmount=0;
    uint public oneEthTotalAmount=0;
    uint public oneUsdtTotalAmount=0;
    uint public oneBnbTotalAmount=0;
    uint public oneFilTotalAmount=0;
    uint public oneAdaTotalAmount=0;
    uint public oneXrpTotalAmount=0;
    uint public oneDogeTotalAmount=0;
    uint public oneDotTotalAmount=0;
    uint public oneSolTotalAmount=0;
    uint public oneUniTotalAmount=0;
    uint public oneBchTotalAmount=0;
    uint public oneLtcTotalAmount=0;
    uint public oneLinkTotalAmount=0;
    uint public oneEosTotalAmount=0;
    uint public oneDiemTotalAmount=0;
    
    TwoDepositAmount public twoBtcTotal;
    TwoDepositAmount public twoEthTotal;
    TwoDepositAmount public twoUsdtTotal;
    TwoDepositAmount public twoBnbTotal;
    TwoDepositAmount public twoFilTotal;
    TwoDepositAmount public twoAdaTotal;
    TwoDepositAmount public twoXrpTotal;
    TwoDepositAmount public twoDogeTotal;
    TwoDepositAmount public twoDotTotal;
    TwoDepositAmount public twoSolTotal;
    TwoDepositAmount public twoUniTotal;
    TwoDepositAmount public twoBchTotal;
    TwoDepositAmount public twoLtcTotal;
    TwoDepositAmount public twoLinkTotal;
    TwoDepositAmount public twoEosTotal;
    TwoDepositAmount public twoDiemTotal;
    
    uint public oneBtcTakeoutAmount=0;
    uint public oneEthTakeoutAmount=0;
    uint public oneUsdtTakeoutAmount=0;
    uint public oneBnbTakeoutAmount=0;
    uint public oneFilTakeoutAmount=0;
    uint public oneAdaTakeoutAmount=0;
    uint public oneXrpTakeoutAmount=0;
    uint public oneDogeTakeoutAmount=0;
    uint public oneDotTakeoutAmount=0;
    uint public oneSolTakeoutAmount=0;
    uint public oneUniTakeoutAmount=0;
    uint public oneBchTakeoutAmount=0;
    uint public oneLtcTakeoutAmount=0;
    uint public oneLinkTakeoutAmount=0;
    uint public oneEosTakeoutAmount=0;
    uint public oneDiemTakeoutAmount=0;
    mapping(uint=>uint) public oneFee;
    mapping(uint=>uint) public twoFee;
    uint public libraFee1=0;
    
    TwoTakeoutAmount public twoBtcTakeout;
    TwoTakeoutAmount public twoEthTakeout;
    TwoTakeoutAmount public twoUsdtTakeout;
    TwoTakeoutAmount public twoBnbTakeout;
    TwoTakeoutAmount public twoFilTakeout;
    TwoTakeoutAmount public twoAdaTakeout;
    TwoTakeoutAmount public twoXrpTakeout;
    TwoTakeoutAmount public twoDogeTakeout;
    TwoTakeoutAmount public twoDotTakeout;
    TwoTakeoutAmount public twoSolTakeout;
    TwoTakeoutAmount public twoUniTakeout;
    TwoTakeoutAmount public twoBchTakeout;
    TwoTakeoutAmount public twoLtcTakeout;
    TwoTakeoutAmount public twoLinkTakeout;
    TwoTakeoutAmount public twoEosTakeout;
    TwoTakeoutAmount public twoDiemTakeout;
    
    mapping(address=>OneTakeout[]) public userOneTakeoutMap;
    mapping(address=>TwoTakeout[]) public userTwoTakeoutMap;
    mapping(address=>TakeoutIncome[]) public takeoutIncomeMap;
    mapping(address=>DividendRecord[]) public incomeRecord;
    address public owner;
    address public internalAddress;
    
    FeeRecord[] public feeRecord;

    constructor(address _priceContract){
        owner = msg.sender;
        priceOracle=PriceOraclelInterface(_priceContract);
        precision = 10**8;
    }
    
    modifier onlyInternal() {
        require(internalAddress != address(0),"not init.");
        require(msg.sender == internalAddress, "no.");
        _;
    }
    modifier onlyOwner() {
        require(owner == msg.sender,"Permission denied");
        _;
    }
    
    function changeOwner(address _newOwner) onlyOwner payable public {
        require(_newOwner != owner,"same");
        owner=_newOwner;
    }
    
    function init(address addr) onlyOwner payable public{
        internalAddress=addr;
    }
    
    function saveDepositOneRecord(uint8 currencyIndex,uint amount) payable onlyInternal public{
        require(msg.sender==internalAddress);
        if(currencyIndex == ethId){
            oneEthTotalAmount=oneEthTotalAmount.add(amount);
        }else if(currencyIndex == btcId){
            oneBtcTotalAmount=oneBtcTotalAmount.add(amount);
        }else if(currencyIndex == usdtId){
            oneUsdtTotalAmount=oneUsdtTotalAmount.add(amount);
        }else if(currencyIndex == bnbId){
            oneBnbTotalAmount=oneBnbTotalAmount.add(amount);
        }else if(currencyIndex == filId){
            oneFilTotalAmount=oneFilTotalAmount.add(amount);
        }else if(currencyIndex == adaId){
            oneAdaTotalAmount=oneAdaTotalAmount.add(amount);
        }else if(currencyIndex == xrpId){
            oneXrpTotalAmount=oneXrpTotalAmount.add(amount);
        }else if(currencyIndex == dogeId){
            oneDogeTotalAmount=oneDogeTotalAmount.add(amount);
        }else if(currencyIndex == dotId){
            oneDotTotalAmount=oneDotTotalAmount.add(amount);
        }else if(currencyIndex == solId){
            oneSolTotalAmount=oneSolTotalAmount.add(amount);
        }else if(currencyIndex == uniId){
            oneUniTotalAmount=oneUniTotalAmount.add(amount);
        }else if(currencyIndex == bchId){
            oneBchTotalAmount=oneBchTotalAmount.add(amount);
        }else if(currencyIndex == ltcId){
            oneLtcTotalAmount=oneLtcTotalAmount.add(amount);
        }else if(currencyIndex == linkId){
            oneLinkTotalAmount=oneLinkTotalAmount.add(amount);
        }else if(currencyIndex == eosId){
            oneEosTotalAmount=oneEosTotalAmount.add(amount);
        }else if(currencyIndex == diemId){
            oneDiemTotalAmount=oneDiemTotalAmount.add(amount);
        }else{
            revert();
        }
    }
    function saveDepositTwoRecord(uint amount1,uint8 currencyIndex2,uint amount2) payable onlyInternal public{
        if(currencyIndex2 == ethId){
            twoEthTotal.libraAmount=twoEthTotal.libraAmount.add(amount1);
            twoEthTotal.amount2=twoEthTotal.amount2.add(amount2);
        }else if(currencyIndex2 == btcId){
            twoBtcTotal.libraAmount=twoBtcTotal.libraAmount.add(amount1);
            twoBtcTotal.amount2=twoBtcTotal.amount2.add(amount2);
        }else if(currencyIndex2 == usdtId){
            twoUsdtTotal.libraAmount=twoUsdtTotal.libraAmount.add(amount1);
            twoUsdtTotal.amount2=twoUsdtTotal.amount2.add(amount2);
        }else if(currencyIndex2 == bnbId){
            twoBnbTotal.libraAmount=twoBnbTotal.libraAmount.add(amount1);
            twoBnbTotal.amount2=twoBnbTotal.amount2.add(amount2);
        }else if(currencyIndex2 == filId){
            twoFilTotal.libraAmount=twoFilTotal.libraAmount.add(amount1);
            twoFilTotal.amount2=twoFilTotal.amount2.add(amount2);
        }else if(currencyIndex2 == adaId){
            twoAdaTotal.libraAmount=twoAdaTotal.libraAmount.add(amount1);
            twoAdaTotal.amount2=twoAdaTotal.amount2.add(amount2);
        }else if(currencyIndex2 == xrpId){
            twoXrpTotal.libraAmount=twoXrpTotal.libraAmount.add(amount1);
            twoXrpTotal.amount2=twoXrpTotal.amount2.add(amount2);
        }else if(currencyIndex2 == dogeId){
            twoDogeTotal.libraAmount=twoDogeTotal.libraAmount.add(amount1);
            twoDogeTotal.amount2=twoDogeTotal.amount2.add(amount2);
        }else if(currencyIndex2 == dotId){
            twoDotTotal.libraAmount=twoDotTotal.libraAmount.add(amount1);
            twoDotTotal.amount2=twoDotTotal.amount2.add(amount2);
        }else if(currencyIndex2 == solId){
            twoSolTotal.libraAmount=twoSolTotal.libraAmount.add(amount1);
            twoSolTotal.amount2=twoSolTotal.amount2.add(amount2);
        }else if(currencyIndex2 == uniId){
            twoUniTotal.libraAmount=twoUniTotal.libraAmount.add(amount1);
            twoUniTotal.amount2=twoUniTotal.amount2.add(amount2);
        }else if(currencyIndex2 == bchId){
            twoBchTotal.libraAmount=twoBchTotal.libraAmount.add(amount1);
            twoBchTotal.amount2=twoBchTotal.amount2.add(amount2);
        }else if(currencyIndex2 == ltcId){
            twoLtcTotal.libraAmount=twoLtcTotal.libraAmount.add(amount1);
            twoLtcTotal.amount2=twoLtcTotal.amount2.add(amount2);
        }else if(currencyIndex2 == linkId){
            twoLinkTotal.libraAmount=twoLinkTotal.libraAmount.add(amount1);
            twoLinkTotal.amount2=twoLinkTotal.amount2.add(amount2);
        }else if(currencyIndex2 == eosId){
            twoEosTotal.libraAmount=twoEosTotal.libraAmount.add(amount1);
            twoEosTotal.amount2=twoEosTotal.amount2.add(amount2);
        }else if(currencyIndex2 == diemId){
            twoDiemTotal.libraAmount=twoDiemTotal.libraAmount.add(amount1);
            twoDiemTotal.amount2=twoDiemTotal.amount2.add(amount2);
        }else{
            revert();
        }
    }
    function saveTakeoutOneRecord(address user,uint8 currencyIndex,uint amount,uint fee,uint time) payable onlyInternal public{
        if(currencyIndex == ethId){
            oneEthTakeoutAmount=oneEthTakeoutAmount.add(amount);
        }else if(currencyIndex == btcId){
            oneBtcTakeoutAmount=oneBtcTakeoutAmount.add(amount);
        }else if(currencyIndex == usdtId){
            oneUsdtTakeoutAmount=oneUsdtTakeoutAmount.add(amount);
        }else if(currencyIndex == bnbId){
            oneBnbTakeoutAmount=oneBnbTakeoutAmount.add(amount);
        }else if(currencyIndex == filId){
            oneFilTakeoutAmount=oneFilTakeoutAmount.add(amount);
        }else if(currencyIndex == adaId){
            oneAdaTakeoutAmount=oneAdaTakeoutAmount.add(amount);
        }else if(currencyIndex == xrpId){
            oneXrpTakeoutAmount=oneXrpTakeoutAmount.add(amount);
        }else if(currencyIndex == dogeId){
            oneDogeTakeoutAmount=oneDogeTakeoutAmount.add(amount);
        }else if(currencyIndex == dotId){
            oneDotTakeoutAmount=oneDotTakeoutAmount.add(amount);
        }else if(currencyIndex == solId){
            oneSolTakeoutAmount=oneSolTakeoutAmount.add(amount);
        }else if(currencyIndex == uniId){
            oneUniTakeoutAmount=oneUniTakeoutAmount.add(amount);
        }else if(currencyIndex == bchId){
            oneBchTakeoutAmount=oneBchTakeoutAmount.add(amount);
        }else if(currencyIndex == ltcId){
            oneLtcTakeoutAmount=oneLtcTakeoutAmount.add(amount);
        }else if(currencyIndex == linkId){
            oneLinkTakeoutAmount=oneLinkTakeoutAmount.add(amount);
        }else if(currencyIndex == eosId){
            oneEosTakeoutAmount=oneEosTakeoutAmount.add(amount);
        }else if(currencyIndex == diemId){
            oneDiemTakeoutAmount=oneDiemTakeoutAmount.add(amount);
        }else{
            revert();
        }
        userOneTakeoutMap[user].push(OneTakeout(user,currencyIndex,amount,fee,time));
        oneFee[currencyIndex]=oneFee[currencyIndex].add(fee);
    }
    function saveTakeoutTwoRecord(address user,uint amount1,uint fee1,uint8 currencyIndex2,uint amount2,uint fee2) payable onlyInternal public{
        
        if(currencyIndex2 == ethId){
            twoEthTakeout.libraAmount=twoEthTakeout.libraAmount.add(amount1);
            twoEthTakeout.amount2=twoEthTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == btcId){
            twoBtcTakeout.libraAmount=twoBtcTakeout.libraAmount.add(amount1);
            twoBtcTakeout.amount2=twoBtcTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == usdtId){
            twoUsdtTakeout.libraAmount=twoUsdtTakeout.libraAmount.add(amount1);
            twoUsdtTakeout.amount2=twoUsdtTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == bnbId){
            twoBnbTakeout.libraAmount=twoBnbTakeout.libraAmount.add(amount1);
            twoBnbTakeout.amount2=twoBnbTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == filId){
            twoFilTakeout.libraAmount=twoFilTakeout.libraAmount.add(amount1);
            twoFilTakeout.amount2=twoFilTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == adaId){
            twoAdaTakeout.libraAmount=twoAdaTakeout.libraAmount.add(amount1);
            twoAdaTakeout.amount2=twoAdaTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == xrpId){
            twoXrpTakeout.libraAmount=twoXrpTakeout.libraAmount.add(amount1);
            twoXrpTakeout.amount2=twoXrpTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == dogeId){
            twoDogeTakeout.libraAmount=twoDogeTakeout.libraAmount.add(amount1);
            twoDogeTakeout.amount2=twoDogeTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == dotId){
            twoDotTakeout.libraAmount=twoDotTakeout.libraAmount.add(amount1);
            twoDotTakeout.amount2=twoDotTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == solId){
            twoSolTakeout.libraAmount=twoSolTakeout.libraAmount.add(amount1);
            twoSolTakeout.amount2=twoSolTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == uniId){
            twoUniTakeout.libraAmount=twoUniTakeout.libraAmount.add(amount1);
            twoUniTakeout.amount2=twoUniTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == bchId){
            twoBchTakeout.libraAmount=twoBchTakeout.libraAmount.add(amount1);
            twoBchTakeout.amount2=twoBchTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == ltcId){
            twoLtcTakeout.libraAmount=twoLtcTakeout.libraAmount.add(amount1);
            twoLtcTakeout.amount2=twoLtcTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == linkId){
            twoLinkTakeout.libraAmount=twoLinkTakeout.libraAmount.add(amount1);
            twoLinkTakeout.amount2=twoLinkTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == eosId){
            twoEosTakeout.libraAmount=twoEosTakeout.libraAmount.add(amount1);
            twoEosTakeout.amount2=twoEosTakeout.amount2.add(amount2);
        }else if(currencyIndex2 == diemId){
            twoDiemTakeout.libraAmount=twoDiemTakeout.libraAmount.add(amount1);
            twoDiemTakeout.amount2=twoDiemTakeout.amount2.add(amount2);
        }else{
            revert();
        }
        userTwoTakeoutMap[user].push(TwoTakeout(user,libraId,amount1,fee1,currencyIndex2,amount2,fee2,block.timestamp));
        libraFee1=libraFee1.add(fee1);
        twoFee[currencyIndex2]=twoFee[currencyIndex2].add(fee2);
    }
    function saveTakeoutRecord(address user,uint amount,uint receivedAmount) payable onlyInternal public{
        takeoutIncomeMap[user].push(TakeoutIncome(user,amount,receivedAmount,block.timestamp));
    }
    
    function getLibraTotalUseable() view internal returns(uint amount){
        amount = twoEthTotal.libraAmount.sub(twoEthTakeout.libraAmount);
        amount = amount.add(twoBtcTotal.libraAmount.sub(twoBtcTakeout.libraAmount));
        amount = amount.add(twoUsdtTotal.libraAmount.sub(twoUsdtTakeout.libraAmount));
        amount = amount.add(twoBnbTotal.libraAmount.sub(twoBnbTakeout.libraAmount));
        amount = amount.add(twoFilTotal.libraAmount.sub(twoFilTakeout.libraAmount));
        
        amount = amount.add(twoAdaTotal.libraAmount.sub(twoAdaTakeout.libraAmount));
        amount = amount.add(twoXrpTotal.libraAmount.sub(twoXrpTakeout.libraAmount));
        amount = amount.add(twoDogeTotal.libraAmount.sub(twoDogeTakeout.libraAmount));
        amount = amount.add(twoDotTotal.libraAmount.sub(twoDotTakeout.libraAmount));
        amount = amount.add(twoSolTotal.libraAmount.sub(twoSolTakeout.libraAmount));
        amount = amount.add(twoUniTotal.libraAmount.sub(twoUniTakeout.libraAmount));
        amount = amount.add(twoBchTotal.libraAmount.sub(twoBchTakeout.libraAmount));
        amount = amount.add(twoLtcTotal.libraAmount.sub(twoLtcTakeout.libraAmount));
        amount = amount.add(twoLinkTotal.libraAmount.sub(twoLinkTakeout.libraAmount));
        amount = amount.add(twoEosTotal.libraAmount.sub(twoEosTakeout.libraAmount));
        amount = amount.add(twoDiemTotal.libraAmount.sub(twoDiemTakeout.libraAmount));
        return amount;
    }
    
    function totalUseableByCurrency(uint8 currencyId) view public returns(uint){
        if(currencyId == ethId){
            return oneEthTotalAmount.add(twoEthTotal.amount2).sub(oneEthTakeoutAmount).sub(twoEthTakeout.amount2);
        }else if(currencyId == btcId){
            return oneBtcTotalAmount.add(twoBtcTotal.amount2).sub(oneBtcTakeoutAmount).sub(twoBtcTakeout.amount2);
        }else if(currencyId == usdtId){
            return oneUsdtTotalAmount.add(twoUsdtTotal.amount2).sub(oneUsdtTakeoutAmount).sub(twoUsdtTakeout.amount2);
        }else if(currencyId == bnbId){
            return oneBnbTotalAmount.add(twoBnbTotal.amount2).sub(oneBnbTakeoutAmount).sub(twoBnbTakeout.amount2);
        }else if(currencyId == filId){
            return oneFilTotalAmount.add(twoFilTotal.amount2).sub(oneFilTakeoutAmount).sub(twoFilTakeout.amount2);
        }else if(currencyId == libraId){
            return getLibraTotalUseable();
        }else if(currencyId == adaId){
            return oneAdaTotalAmount.add(twoAdaTotal.amount2).sub(oneAdaTakeoutAmount).sub(twoAdaTakeout.amount2);
        }else if(currencyId == xrpId){
            return oneXrpTotalAmount.add(twoXrpTotal.amount2).sub(oneXrpTakeoutAmount).sub(twoXrpTakeout.amount2);
        }else if(currencyId == dogeId){
            return oneDogeTotalAmount.add(twoDogeTotal.amount2).sub(oneDogeTakeoutAmount).sub(twoDogeTakeout.amount2);
        }else if(currencyId == dotId){
            return oneDotTotalAmount.add(twoDotTotal.amount2).sub(oneDotTakeoutAmount).sub(twoDotTakeout.amount2);
        }else if(currencyId == solId){
            return oneSolTotalAmount.add(twoSolTotal.amount2).sub(oneSolTakeoutAmount).sub(twoSolTakeout.amount2);
        }else if(currencyId == uniId){
            return oneUniTotalAmount.add(twoUniTotal.amount2).sub(oneUniTakeoutAmount).sub(twoUniTakeout.amount2);
        }else if(currencyId == bchId){
            return oneBchTotalAmount.add(twoBchTotal.amount2).sub(oneBchTakeoutAmount).sub(twoBchTakeout.amount2);
        }else if(currencyId == ltcId){
            return oneLtcTotalAmount.add(twoLtcTotal.amount2).sub(oneLtcTakeoutAmount).sub(twoLtcTakeout.amount2);
        }else if(currencyId == linkId){
            return oneLinkTotalAmount.add(twoLinkTotal.amount2).sub(oneLinkTakeoutAmount).sub(twoLinkTakeout.amount2);
        }else if(currencyId == eosId){
            return oneEosTotalAmount.add(twoEosTotal.amount2).sub(oneEosTakeoutAmount).sub(twoEosTakeout.amount2);
        }else if(currencyId == diemId){
            return oneDiemTotalAmount.add(twoDiemTotal.amount2).sub(oneDiemTakeoutAmount).sub(twoDiemTakeout.amount2);
        }else{
            revert();
        }
    }
    
    function totalUseable() view public returns(uint totalBalance){
        uint t1 = totalUseable1();
        uint t2 = totalUseable2();
        totalBalance = t1.add(t2);
        return totalBalance;
    }
    function totalUseable1() view internal returns(uint total){
        uint libraPrice=priceOracle.getThePrice(libraId);
        uint btcPrice=priceOracle.getThePrice(btcId);
        uint ethPrice=priceOracle.getThePrice(ethId);
        uint bnbPrice=priceOracle.getThePrice(bnbId);
        uint filPrice=priceOracle.getThePrice(filId);

        total=totalUseableByCurrency(libraId).mul(libraPrice).div(precision);
        total=total.add(totalUseableByCurrency(btcId).mul(btcPrice).div(precision));
        total=total.add(totalUseableByCurrency(ethId).mul(ethPrice).div(precision));
        total=total.add(totalUseableByCurrency(usdtId));
        total=total.add(totalUseableByCurrency(bnbId).mul(bnbPrice).div(precision));
        total=total.add(totalUseableByCurrency(filId).mul(filPrice).div(precision));
        return total;
    }
    function totalUseable2() view internal returns(uint total){
        uint adaPrice=priceOracle.getThePrice(adaId);
        uint xrpPrice=priceOracle.getThePrice(xrpId);
        uint dogePrice=priceOracle.getThePrice(dogeId);
        uint dotPrice=priceOracle.getThePrice(dotId);
        uint solPrice=priceOracle.getThePrice(solId);
        uint uniPrice=priceOracle.getThePrice(uniId);
        uint bchPrice=priceOracle.getThePrice(bchId);
        uint ltcPrice=priceOracle.getThePrice(ltcId);
        uint linkPrice=priceOracle.getThePrice(linkId);
        uint eosPrice=priceOracle.getThePrice(eosId);
        uint diemPrice=priceOracle.getThePrice(diemId);

        total=totalUseableByCurrency(adaId).mul(adaPrice).div(precision);
        total=total.add(totalUseableByCurrency(xrpId).mul(xrpPrice).div(precision));
        total=total.add(totalUseableByCurrency(dogeId).mul(dogePrice).div(precision));
        total=total.add(totalUseableByCurrency(dotId).mul(dotPrice).div(precision));
        total=total.add(totalUseableByCurrency(solId).mul(solPrice).div(precision));
        total=total.add(totalUseableByCurrency(uniId).mul(uniPrice).div(precision));
        total=total.add(totalUseableByCurrency(bchId).mul(bchPrice).div(precision));
        total=total.add(totalUseableByCurrency(ltcId).mul(ltcPrice).div(precision));
        total=total.add(totalUseableByCurrency(linkId).mul(linkPrice).div(precision));
        total=total.add(totalUseableByCurrency(eosId).mul(eosPrice).div(precision));
        total=total.add(totalUseableByCurrency(diemId).mul(diemPrice).div(precision));
        return total;
    }
    
    function totalOneUseableByCurrency(uint8 currencyId) view public returns(uint){
        if(currencyId == ethId){
            return oneEthTotalAmount.sub(oneEthTakeoutAmount);
        }else if(currencyId == btcId){
            return oneBtcTotalAmount.sub(oneBtcTakeoutAmount);
        }else if(currencyId == usdtId){
            return oneUsdtTotalAmount.sub(oneUsdtTakeoutAmount);
        }else if(currencyId == bnbId){
            return oneBnbTotalAmount.sub(oneBnbTakeoutAmount);
        }else if(currencyId == filId){
            return oneFilTotalAmount.sub(oneFilTakeoutAmount);
        }else if(currencyId == adaId){
            return oneAdaTotalAmount.sub(oneAdaTakeoutAmount);
        }else if(currencyId == xrpId){
            return oneXrpTotalAmount.sub(oneXrpTakeoutAmount);
        }else if(currencyId == dogeId){
            return oneDogeTotalAmount.sub(oneDogeTakeoutAmount);
        }else if(currencyId == dotId){
            return oneDotTotalAmount.sub(oneDotTakeoutAmount);
        }else if(currencyId == solId){
            return oneSolTotalAmount.sub(oneSolTakeoutAmount);
        }else if(currencyId == uniId){
            return oneUniTotalAmount.sub(oneUniTakeoutAmount);
        }else if(currencyId == bchId){
            return oneBchTotalAmount.sub(oneBchTakeoutAmount);
        }else if(currencyId == ltcId){
            return oneLtcTotalAmount.sub(oneLtcTakeoutAmount);
        }else if(currencyId == linkId){
            return oneLinkTotalAmount.sub(oneLinkTakeoutAmount);
        }else if(currencyId == eosId){
            return oneEosTotalAmount.sub(oneEosTakeoutAmount);
        }else if(currencyId == diemId){
            return oneDiemTotalAmount.sub(oneDiemTakeoutAmount);
        }else{
            revert();
        }
    }
    function totalTwoUseable1ByCurrency(uint8 currencyId) view public returns(uint){
        if(currencyId == ethId){
            return twoEthTotal.libraAmount.sub(twoEthTakeout.libraAmount);
        }else if(currencyId == btcId){
            return twoBtcTotal.libraAmount.sub(twoBtcTakeout.libraAmount);
        }else if(currencyId == usdtId){
            return twoUsdtTotal.libraAmount.sub(twoUsdtTakeout.libraAmount);
        }else if(currencyId == bnbId){
            return twoBnbTotal.libraAmount.sub(twoBnbTakeout.libraAmount);
        }else if(currencyId == filId){
            return twoFilTotal.libraAmount.sub(twoFilTakeout.libraAmount);
        }else if(currencyId == adaId){
            return twoAdaTotal.libraAmount.sub(twoAdaTakeout.libraAmount);
        }else if(currencyId == xrpId){
            return twoXrpTotal.libraAmount.sub(twoXrpTakeout.libraAmount);
        }else if(currencyId == dogeId){
            return twoDogeTotal.libraAmount.sub(twoDogeTakeout.libraAmount);
        }else if(currencyId == dotId){
            return twoDotTotal.libraAmount.sub(twoDotTakeout.libraAmount);
        }else if(currencyId == solId){
            return twoSolTotal.libraAmount.sub(twoSolTakeout.libraAmount);
        }else if(currencyId == uniId){
            return twoUniTotal.libraAmount.sub(twoUniTakeout.libraAmount);
        }else if(currencyId == bchId){
            return twoBchTotal.libraAmount.sub(twoBchTakeout.libraAmount);
        }else if(currencyId == ltcId){
            return twoLtcTotal.libraAmount.sub(twoLtcTakeout.libraAmount);
        }else if(currencyId == linkId){
            return twoLinkTotal.libraAmount.sub(twoLinkTakeout.libraAmount);
        }else if(currencyId == eosId){
            return twoEosTotal.libraAmount.sub(twoEosTakeout.libraAmount);
        }else if(currencyId == diemId){
            return twoDiemTotal.libraAmount.sub(twoDiemTakeout.libraAmount);
        }else{
            revert();
        }
    }
    function totalTwoUseable2ByCurrency(uint8 currencyId) view public returns(uint){
        if(currencyId == ethId){
            return twoEthTotal.amount2.sub(twoEthTakeout.amount2);
        }else if(currencyId == btcId){
            return twoBtcTotal.amount2.sub(twoBtcTakeout.amount2);
        }else if(currencyId == usdtId){
            return twoUsdtTotal.amount2.sub(twoUsdtTakeout.amount2);
        }else if(currencyId == bnbId){
            return twoBnbTotal.amount2.sub(twoBnbTakeout.amount2);
        }else if(currencyId == filId){
            return twoFilTotal.amount2.sub(twoFilTakeout.amount2);
        }else if(currencyId == adaId){
            return twoAdaTotal.amount2.sub(twoAdaTakeout.amount2);
        }else if(currencyId == xrpId){
            return twoXrpTotal.amount2.sub(twoXrpTakeout.amount2);
        }else if(currencyId == dogeId){
            return twoDogeTotal.amount2.sub(twoDogeTakeout.amount2);
        }else if(currencyId == dotId){
            return twoDotTotal.amount2.sub(twoDotTakeout.amount2);
        }else if(currencyId == solId){
            return twoSolTotal.amount2.sub(twoSolTakeout.amount2);
        }else if(currencyId == uniId){
            return twoUniTotal.amount2.sub(twoUniTakeout.amount2);
        }else if(currencyId == bchId){
            return twoBchTotal.amount2.sub(twoBchTakeout.amount2);
        }else if(currencyId == ltcId){
            return twoLtcTotal.amount2.sub(twoLtcTakeout.amount2);
        }else if(currencyId == linkId){
            return twoLinkTotal.amount2.sub(twoLinkTakeout.amount2);
        }else if(currencyId == eosId){
            return twoEosTotal.amount2.sub(twoEosTakeout.amount2);
        }else if(currencyId == diemId){
            return twoDiemTotal.amount2.sub(twoDiemTakeout.amount2);
        }else{
            revert();
        }
    }
    function takeoutIncomeRecordSize(address addr) view public returns(uint){
        return takeoutIncomeMap[addr].length;
    }
    
    function userOneTakeoutSize(address addr) view public returns(uint){
        return userOneTakeoutMap[addr].length;
    }
    
    function userTwoTakeoutSize(address addr) view public returns(uint){
        return userTwoTakeoutMap[addr].length;
    }
    
    function saveFee1(address user,uint8 currencyId,uint feeAmount) onlyInternal payable public{
		if(currencyId==libraId){
			//销毁
			feeRecord.push(FeeRecord(user,currencyId,feeAmount,block.timestamp));
			libraDestroyAmount=libraDestroyAmount.add(feeAmount);
		}else{
			feeRecord.push(FeeRecord(user,currencyId,feeAmount,block.timestamp));
			if(currencyId==btcId){
				btcFeeAmount=btcFeeAmount.add(feeAmount);
			}else if(currencyId==ethId){
				ethFeeAmount=ethFeeAmount.add(feeAmount);
			}else if(currencyId==usdtId){
				usdtFeeAmount=usdtFeeAmount.add(feeAmount);
			}else if(currencyId==bnbId){
				bnbFeeAmount=bnbFeeAmount.add(feeAmount);
			}else if(currencyId==filId){
				filFeeAmount=filFeeAmount.add(feeAmount);
			}else if(currencyId==adaId){
				adaFeeAmount=adaFeeAmount.add(feeAmount);
			}else if(currencyId==xrpId){
				xrpFeeAmount=xrpFeeAmount.add(feeAmount);
			}else if(currencyId==dogeId){
				dogeFeeAmount=dogeFeeAmount.add(feeAmount);
			}else if(currencyId==dotId){
				dotFeeAmount=dotFeeAmount.add(feeAmount);
			}else if(currencyId==solId){
				solFeeAmount=solFeeAmount.add(feeAmount);
			}else if(currencyId==uniId){
				uniFeeAmount=uniFeeAmount.add(feeAmount);
			}else if(currencyId==bchId){
				bchFeeAmount=bchFeeAmount.add(feeAmount);
			}else if(currencyId==ltcId){
				ltcFeeAmount=ltcFeeAmount.add(feeAmount);
			}else if(currencyId==linkId){
				linkFeeAmount=linkFeeAmount.add(feeAmount);
			}else if(currencyId==eosId){
				eosFeeAmount=eosFeeAmount.add(feeAmount);
			}else if(currencyId==diemId){
				diemFeeAmount=diemFeeAmount.add(feeAmount);
			}
		}
	}
	
	function saveFee2(address user,uint destroyAmount,uint8 currencyId,uint feeAmount) onlyInternal payable public{	
		saveFee1(user,libraId,destroyAmount);
		saveFee1(user,currencyId,feeAmount);
	}
	
	
    function queryIncomeSize(address _from) view public returns(uint){
        return incomeRecord[_from].length;
    }
    
    function saveIncome(uint _type,address _userAddress,uint _incomeAmount,uint _time) onlyInternal payable public{
        incomeRecord[_userAddress].push(DividendRecord(_type,_userAddress,_incomeAmount,_time));
    }
    
    function queryPrice(uint cIndex) view internal returns(uint price){
        if(cIndex==libraId){
            return priceOracle.getThePrice(libraId);
        }else if(cIndex==btcId){
            return priceOracle.getThePrice(btcId);
        }else if(cIndex==ethId){
            return priceOracle.getThePrice(ethId);
        }else if(cIndex==usdtId){
            return 100000000;
        }else if(cIndex==bnbId){
            return priceOracle.getThePrice(bnbId);
        }else if(cIndex==filId){
            return priceOracle.getThePrice(filId);
        }else if(cIndex==adaId){
            return priceOracle.getThePrice(adaId);
        }else if(cIndex==xrpId){
            return priceOracle.getThePrice(xrpId);
        }else if(cIndex==dogeId){
            return priceOracle.getThePrice(dogeId);
        }else if(cIndex==dotId){
            return priceOracle.getThePrice(dotId);
        }else if(cIndex==solId){
            return priceOracle.getThePrice(solId);
        }else if(cIndex==uniId){
            return priceOracle.getThePrice(uniId);
        }else if(cIndex==bchId){
            return priceOracle.getThePrice(bchId);
        }else if(cIndex==ltcId){
            return priceOracle.getThePrice(ltcId);
        }else if(cIndex==linkId){
            return priceOracle.getThePrice(linkId);
        }else if(cIndex==eosId){
            return priceOracle.getThePrice(eosId);
        }else if(cIndex==diemId){
            return priceOracle.getThePrice(diemId);
        }
        revert();
    }

    function queryFeeBalance() view public returns(uint){
        uint balance = btcFeeAmount.mul(priceOracle.getThePrice(btcId));
        balance=balance.add(ethFeeAmount.mul(priceOracle.getThePrice(ethId)));
        balance=balance.add(usdtFeeAmount.mul(priceOracle.getThePrice(usdtId)));
        balance=balance.add(bnbFeeAmount.mul(priceOracle.getThePrice(bnbId)));
        balance=balance.add(filFeeAmount.mul(priceOracle.getThePrice(filId)));
        
        balance=balance.add(adaFeeAmount.mul(priceOracle.getThePrice(adaId)));
        balance=balance.add(xrpFeeAmount.mul(priceOracle.getThePrice(xrpId)));
        balance=balance.add(dogeFeeAmount.mul(priceOracle.getThePrice(dogeId)));
        balance=balance.add(dotFeeAmount.mul(priceOracle.getThePrice(dotId)));
        if(solFeeAmount > 0){
            balance=balance.add(solFeeAmount.mul(priceOracle.getThePrice(solId)));
        }
        if(uniFeeAmount > 0){
            balance=balance.add(uniFeeAmount.mul(priceOracle.getThePrice(uniId)));
        }
        balance=balance.add(bchFeeAmount.mul(priceOracle.getThePrice(bchId)));
        balance=balance.add(ltcFeeAmount.mul(priceOracle.getThePrice(ltcId)));
        balance=balance.add(linkFeeAmount.mul(priceOracle.getThePrice(linkId)));
        if(eosFeeAmount > 0){
            balance=balance.add(eosFeeAmount.mul(priceOracle.getThePrice(eosId)));
        }
        balance=balance.add(diemFeeAmount.mul(priceOracle.getThePrice(diemId)));
        return balance.div(10**8);
    }
}
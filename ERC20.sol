//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 <0.9.0; // ---------------------------------------------------------------------------- // EIP-20: ERC-20 Token Standard // https://eips.ethereum.org/EIPS/eip-20 // -----------------------------------------
//Unlike ETH (Ethereum’s native cryptocurrency), ERC-20 tokens aren’t held by accounts. The tokens only exist inside a contract, which is like a self-contained database. It specifies the rules for the tokens (i.e., name, symbol, divisibility) and keeps a list that maps users’ balances to their Ethereum addresses.
interface ERC20Interface { 

  function totalSupply() external view returns (uint); 
  function balanceOf(address tokenOwner) external view returns (uint balance); 
  function transfer(address to, uint tokens) external returns (bool success);

  function approve(address spender, uint tokens) external returns (bool success);
  function allowance(address tokenOwner, address spender) external view returns (uint remaining);
  function transferFrom(address from, address to, uint tokens) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}


contract Block is ERC20Interface {
  string public name = 'Block';
  string public symbol = 'BLK';

  string public decimal = 0;
  uint public override totalSupply; // to override interface beloged function
  address public founder;
  mapping(address => uint) public balances; // track perticular user balances - default 0
  mapping(address=>mapping(address=>uint)) allowed;


  constructor() {
    totalSupply = 1000000;
    founder = msg.sender; // who deployed contract - add0
    balances[founder] = totalSupply; // founder has all supply   
  }

// to override interface beloged function - perticular user balance check
  function balanceOf(address tokenOwner) public view override returns(uint balance) {
    return balances[tokenOwner];
  }

  // send tokens - how much/amount-> bool status (zaree TAKA dilam koto & amr roilo koto tar record -> amount)
  // founder add0 r 1000000 tokens theke addB user k 1000 tokens dilam
  function transfer(address to, uint tokens) public override returns (bool success) {    
    require (balances[msg.sender] >= tokens);
    balances[to]+=tokens; //balances[to] = balances[to] + tokens  
    balances[msg.sender] -= tokens; 
    emit Transfer(msg.sender, to, tokens);
    return true;
  }

//approve is another useful function from a programmability standpoint. With this function, you can limit the number of tokens that a smart contract can withdraw from your balance. Without it, you run the risk of the contract malfunctioning (or being exploited) and stealing all of your funds. 
    // addB abr tar 1000 tokens theke addC k 100 tokens dilo -> set a limit of 100 tokens
  //msg.sender allowed spender to use <tokens> (ami z Taka dilam ata amar record & zare dilm tr record -> address)
  function approve(address spender, uint tokens) public override returns (bool success) {
    require (balances[msg.sender] >= tokens); // @param = uint tokens
    require(tokens > 0);
    // addB abr tar 1000 tokens theke addC k 100 tokens dilo approval use r jnno
    allowed[msg.sender][spender] = tokens; // msg.sender allowed spender to use this much <tokens>
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  
  // tokenOwner approved this amount to spender for taking - approval check kore allowance
  // addB owner age addC k koto dise check -> 100 dise age
  function allowance(address tokenOwner, address spender) external view returns (uint noOfToken) {
      return allowed[tokenOwner][spender]; // -> approve() fun e record kora hoise
  }

//Like transfer, transferFrom used to move tokens, but those tokens don’t necessarily need to belong to the person/add0/founder who calling the contract. 

// addA has given 100 tokens allowance to addB, now addB can recv 100 or lower than 100
// addA akohn addB k 90 tokens dibe cox addB 90 chaise
  function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
    require(allowed[from][to] >= tokens); // 100 >= 90 (100 >= @token=90)
    require(balances[from] >= tokens);
    balances[from] -= tokens;
    balances[to] += tokens;
    return true;
  }

}




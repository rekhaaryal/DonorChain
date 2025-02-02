// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/access/AccessControl.sol";




/// @title factory for tender
/// @author Ujjwal Karki
/// @notice you can use this contract to generate multiple tenders and act upon based on the roles provided

contract tenderFactory is AccessControl{
    /** encrypted bytes32 identifier for authorizer */
    bytes32  public constant AUTHORIZER_ROLE = keccak256("AUTHORIZER_ROLE");
 

    address public admin;
    uint public index;

    // only contains registered tender addresees after deployed
    address[] deployedAuthorizedTenders;

   
     event createdTender(address indexed owner,address  deployedTender,string  category,string image,uint createTime);
     event registeredProtocol(uint regNumber,address indexed client,string pdf,uint registeredTime);
    
    
    
    constructor(){
        admin=msg.sender;
        roles[msg.sender]="admin";
          _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

/// @dev for  a single protocol with different informations
    struct protocol{
        string url;
        string image;
        string category;
        bool  validated;
        address beneficiary;
        uint deadline;
        uint minimumContribution;
        uint target;
        uint number;
    }
    mapping(address => protocol[])public protocols;
    mapping(uint => protocol) public protocolTrack;

mapping (address => string) public roles;

address[] public authorizers;



modifier onlyAdmin{
require(admin == msg.sender, "caller is not an admin");
_;
}

/// @dev this function registers the protocol for validation of a specific benefiicary
   function registerProtocol(uint _min,uint _deadline,uint _target,string memory _url,string memory _image,string memory _category)public {
       require(!hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "caller is an Admin");
       require(!hasRole(AUTHORIZER_ROLE, msg.sender), "caller is an Authorizer");
       protocol memory item = protocol({
           url: _url,
           beneficiary: msg.sender,
           category: _category,
           validated: false,
           minimumContribution: _min,
           target: _target,
           deadline: _deadline,
           image: _image,
           number: index
       });
       protocols[msg.sender].push(item);
       protocolTrack[index]=item;
   
   emit registeredProtocol(index,msg.sender,_url,block.timestamp);
   index++;
   
     
   }


//@dev internal function to create tender after te validation of protocol by authorizer
   function createTender(address creator,uint _deadline1,uint _target,uint _minimum,string memory _PdfUrl,uint num) internal {
         tender tenderPointer=new tender();
         tenderPointer.registerTender(_target,_minimum,_PdfUrl,_deadline1,msg.sender,creator);
         deployedAuthorizedTenders.push(address(tenderPointer));
        
        emit createdTender(creator,address(tenderPointer),protocolTrack[num].category,protocolTrack[num].image,block.timestamp);
    }

/// @dev authorizer uses this function to validate the protocols
/// @dev creates tender after authorizing the protocol of a givan client 
   function validateProtocol(address _client,uint protocolNum )public  {
       require(hasRole(AUTHORIZER_ROLE, msg.sender), "caller must be  an Authorizer");

       protocol[] storage list = protocols[_client];
       protocol memory Protocol;
       bool protocolFound = false;
       
       for(uint i = 0; i < list.length; i++) {
           
           if(list[i].number == protocolNum) {
               require(!list[i].validated,"already validated");
               Protocol = list[i];
               Protocol.validated = true;
               protocolTrack[protocolNum] = Protocol;
               protocols[_client][i] = Protocol;
              protocolFound = true;
               
           }
       }
       
       
       require(protocolFound, " not associated with this address");
       
       createTender(_client, Protocol.deadline, Protocol.target, Protocol.minimumContribution, Protocol.url, protocolNum);
   }
   

   function getProtocol() public view returns(protocol[] memory){
        protocol[] memory list = protocols[msg.sender];
       return list;
   }


  


/// @dev admin can grant role to other accouts for the role of authorizer
   function grantAuthorityRole(address _account)public onlyAdmin{
    require(!hasRole(AUTHORIZER_ROLE, _account), "this address is already an authorizer");
       grantRole(AUTHORIZER_ROLE, _account);
       roles[_account] = "authorizer";
       authorizers.push(_account);
    
   }

 function filterAuthorizerArray(address acc) internal {
// address[] memory refinedArray = new address[](authorizers.length);

// uint count = 0;
// for(uint i=0;i<authorizers.length;i++){
// if(authorizers[i] != acc){
//     refinedArray[count] = authorizers[i];
// }
// }

// assembly {
//     mstore(refinedArray,count)
// }

// authorizers = refinedArray;



for(uint i=0;i<authorizers.length;i++){
    if(authorizers[i] == acc){
        if(i < (authorizers.length -1)){
            authorizers[i] = authorizers[authorizers.length -1];
            
        }
        authorizers.pop();
        break;
    }
}

 }

    function revokeAuthorityRole(address _account)public onlyAdmin{
         require(hasRole(AUTHORIZER_ROLE, _account), "this address wasn't  the authorizer");
       revokeRole(AUTHORIZER_ROLE, _account);
       roles[_account]="";

       filterAuthorizerArray(_account);
    }


    function getCurrentAuthorizers() public view returns(address[] memory){
return authorizers;
        
    }
    

   
   function getYourRole()public view returns(string memory){
       return roles[msg.sender];
   }
    function getDeployedTenders() public view returns ( address[] memory ) {
        return deployedAuthorizedTenders;
    }

    function getUnauthorizedProtocols() public view returns(protocol[] memory ) {
  require(hasRole(AUTHORIZER_ROLE,msg.sender),"only call is allowed from authorizer");
  protocol[] memory lists = new protocol[](index);
  for(uint i=0;i<index;i++){
      if(!protocolTrack[i].validated){
          lists[i]=protocolTrack[i];
      }
  }
  return lists;

}

}




contract tender{
   
    address public owner;
    address public authorizer;
    string public pdfUrl;
    uint256 public minimumContribution;
    uint public deadline;
    uint256 public target;
    uint256 public raisedtarget;
    uint256 public noOfdonors;
    uint256 public numRequests;
    uint256 public numofregisteredTender;
    bool public destroyed;



event donorEvent(address indexed donor,uint amount,uint time);

     

    constructor(){
    
      destroyed=false;
    }


    struct Request {
        string description;
        uint256 value;
        bool completed;
        uint256 noOfVoters;
        address payable recipient;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    
     mapping(address => uint256) public donors;

    function registerTender(uint256 _target,uint256 _minimum,  string memory _url,uint _deadline,address _authorizer,address _benificiary) external  {
         require(numofregisteredTender == 0, "only one tender");
          owner=payable(_benificiary);
        target = _target;
        minimumContribution = _minimum;
        pdfUrl = _url;
        deadline=block.timestamp+ _deadline*60;
        authorizer=_authorizer;
        numofregisteredTender++;
    }


    function donate() public payable {
          require(block.timestamp < deadline,"you cant donate");
          require(!(owner==msg.sender),"owner can't donate self");
            require(msg.value <= target, "donation greater than target");
            require(numRequests == 0, "raised target has already mey target");

        require(
            msg.value >= minimumContribution,
            "Minimum donation is not met"
        );
        if (donors[msg.sender] == 0) {
            noOfdonors++;
        }
        donors[msg.sender] = msg.value + donors[msg.sender];
        raisedtarget += msg.value;
        emit donorEvent(msg.sender,msg.value,block.timestamp);
    }


     

    modifier onlyowner() {
         require(!destroyed,"contract is not available");
        require(
            msg.sender == owner,
            "Only owner can calll this function"
        );
        _;
    }

    modifier onlydonor() {
        require(!destroyed,"contract is not available");
        require(donors[msg.sender] > 0, "Only donors can call this function");
        _;
    }

    modifier shouldnotDestroy{

        require(!destroyed,"contract is dstroyed");
        _;
    }


      function refund() public onlydonor shouldnotDestroy{
        require(block.timestamp <  deadline && raisedtarget < target,"You are not eligible for refund");
        payable(msg.sender).transfer(donors[msg.sender]);
        donors[msg.sender]=0;
        if(address(this).balance==0){
            destroyed=true;
        }

      }


/// @dev returns state of the tender 

        function readTenderStatus()public view returns(address,string memory,uint,uint,uint,uint,uint,uint,address,bool){
            return(
                authorizer,
                
            pdfUrl,
            target,
            deadline,
            minimumContribution,
            raisedtarget,
            noOfdonors,
            numRequests,
            owner,
            destroyed
        );
    }


    function createRequest( string memory _description,address payable _recipient,uint256 _value) public payable onlyowner shouldnotDestroy {
        require(block.timestamp >= deadline && raisedtarget < target,"doesn't meet request criteria");
        Request storage newRequest = requests[numRequests];
       
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
         numRequests++;
    }

    function voteRequest(uint256 _requestNo) public onlydonor shouldnotDestroy{
        require(donors[msg.sender] > 0, "YOu must be contributor");
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.voters[msg.sender] == false,
            "You have already voted"
        );
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function settleRequest(uint256 _requestNo) public onlyowner shouldnotDestroy {
        require(raisedtarget <= target);
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.completed == false,
            "The request has been completed"
        );
        require(
            thisRequest.noOfVoters > noOfdonors / 2,
            "Majority does not support"
        );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }


//@dev can't use this approach because of nested mapping inside struct;
    // function getTotalRequestStatus() public view returns(Request[] memory){
    //     Request[] memory requestLists = new Request[](numRequests);
    //     for(uint i=0;i < requestLists.length;i++){
    //         Request[] memory extractedRequest = requests[i];
    //         requestLists.push(extractedRequest);
    //     }

    //     return requestLists;

    // }
 function getRequeststatus(uint256 _i)
        public
        view
        returns (
            uint256,
            bool,
            uint256,
            address,
            uint256,
            string memory,
            address,
            uint256
        )
    {
        return (
            numofregisteredTender,
            requests[_i].completed,
            requests[_i].value,
            requests[_i].recipient,
            requests[_i].noOfVoters,
            requests[_i].description,
            owner,
            noOfdonors
        );
    }

    function getContractBalance()public view returns(uint){
        return address(this).balance;
    }

   

   

    
}

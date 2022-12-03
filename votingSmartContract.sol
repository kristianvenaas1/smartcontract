//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.7.0<0.9.0;

contract Ballot {

    //method to crete your own data type

    struct Voter {
        uint vote;
        bool voted;
        uint weight;
    }
    
    
    struct Proposal {
        string name; // name of the proposal
        uint voteCount; // number of votes

    }

    Proposal[] public proposals;

    mapping(address => Voter) public voters;

    address public chairperson;

    constructor(string[] memory proposalNames) {

        chairperson = msg.sender;

        voters[chairperson].weight = 1;

        for(uint i=0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }

    }


    //function for authenticate votes

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson,
                'Only the chairperson can give access to vote');

        require(!voters[voter].voted,
        'The voter has already voted');

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    // function for votiing

    function vote(uint proposal) public  {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, 'Has no right to vote');
        require(!sender.voted, 'Already voted');
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;

    }

    //functions for showing the results

    //function that shows the winner proposal by integer

    function winningProposal() public view returns (uint winningProposal_) {
        
        uint winningVoteCount = 0;
            for(uint i = 0; i < proposals.length; i++) {
                if(proposals[i].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[i].voteCount;
                    winningProposal_ = i;
                }
            }
    }

    //function that shows the winner
    
    function winningName() public view returns (string memory winningName_) {
        winningName_ = proposals[winningProposal()].name;
    }

}

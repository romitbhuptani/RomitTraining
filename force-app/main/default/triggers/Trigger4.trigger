trigger Trigger4 on Opportunity (before insert) {
    for(Opportunity opp : Trigger.new){
        opp.type='New Customer';
    }
}
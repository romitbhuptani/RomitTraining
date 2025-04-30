trigger Trigger6 on Opportunity (after update) {
    List<Opportunity> oldOpp = Trigger.old;
    List<Opportunity> newOpp = Trigger.new;
    for(integer i = 0 ; i < oldOpp.size() ; i++){
        if(oldOpp[i].Name != newOpp[i].Name){
            TriggerForTask6.TriggerAfterInsert(newOpp[i]);
        }
    }
}
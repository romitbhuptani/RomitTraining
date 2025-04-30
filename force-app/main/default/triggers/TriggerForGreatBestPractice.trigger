trigger TriggerForGreatBestPractice on Contact (before insert , before update) {
    if(Trigger.isInsert){
    GreatHandler.handleTriggerInsert(Trigger.New);
    }
    if(Trigger.isUpdate){
        GreatHandler.handleTriggerUpdate(Trigger.Old, Trigger.New);
    }
}
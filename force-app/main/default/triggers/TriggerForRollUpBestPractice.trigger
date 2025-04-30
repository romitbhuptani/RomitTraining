trigger TriggerForRollUpBestPractice on Contact (after insert , after update , before delete) {
    if(Trigger.isInsert){
        RollUpHandler.handleTriggerInsert(Trigger.New);
    }
    else if(Trigger.isUpdate){
        RollUpHandler.handleTriggerUpdate(Trigger.Old, Trigger.New);
    }
    else if(Trigger.isDelete){
        RollUpHandler.handleTriggerDelete(Trigger.Old);
    }
}
trigger TriggerForSheep on Contact (after update) {
    List<Contact> newContacts = Trigger.New;
    List<Contact> oldContacts = Trigger.Old;
    for(integer i = 0; i < newContacts.size(); i++){
        if(newContacts[i].AccountId != null && oldContacts[i].AccountId != null && newContacts[i].AccountId!=oldContacts[i].AccountId){
            List<Contact> con = [Select Id from Contact where AccountId = :oldContacts[i].AccountId];
            for(Contact c : con){
                if(c.Id != oldContacts[i].Id){
                c.AccountId = newContacts[i].AccountId;
                update c;
                }
            }
        }
    }
}
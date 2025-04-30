trigger TriggerForRollUp on Contact (after insert , after update , before delete) {
    if(Trigger.isInsert){
        for(Contact con  : Trigger.New){
            if(con.AccountId != null && con.Amount__c!=null){

                Account acc = [Select Id,Total_Amount__c from Account where Id =: con.AccountId];
                if(acc.Total_Amount__c==null){
                    acc.Total_Amount__c = 0;
                }
                acc.Total_Amount__c += con.Amount__c;
                update acc;
            }
        }
    }
    else if(Trigger.isUpdate){
        List<Contact> newContacts = Trigger.New;
        List<Contact> oldContacts = Trigger.Old;
        for(integer i = 0; i<newContacts.size(); i++){
            if(newContacts[i].AccountId != null ){
                if(oldContacts[i].Amount__c != newContacts[i].Amount__c){
                    Account acc = [Select Id,Total_Amount__c from Account where Id =: newContacts[i].AccountId];
                    if(acc.Total_Amount__c==null){
                        acc.Total_Amount__c = 0;
                        acc.Total_Amount__c += newContacts[i].Amount__c;
                        update acc;
                        continue;
                    }
                    if(oldContacts[i].Amount__c != null){
                        acc.Total_Amount__c -=  oldContacts[i].Amount__c;
                    }
                    if(newContacts[i].Amount__c != null){
                        acc.Total_Amount__c += newContacts[i].Amount__c;
                    }
                    
                    update acc;
            }
        } 
    }
}
    else if(Trigger.isDelete){
        for(Contact con : Trigger.Old){
            if(con.AccountId != null && con.Amount__c!=null){
                Account acc = [Select Id,Total_Amount__c from Account where Id =: con.AccountId];
                acc.Total_Amount__c -= con.Amount__c;
                update acc;
            }
        }
    }
}
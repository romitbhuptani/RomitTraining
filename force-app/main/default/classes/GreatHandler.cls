public with sharing class GreatHandler {
    public static void handleTriggerInsert(List<Contact> newContacts) {
        for(Contact con : newContacts){
            if(con.Amount_Great__c !=null && con.AccountId != null){
                Account acc = [Select Id, Max_Amount__c from Account where Id = :con.AccountId ];
                if(acc.Max_Amount__c !=null){
                integer totalAmount = Integer.valueOf(con.Amount_Great__c);
                String lastName = con.LastName;
                integer count = 1;
                if(con.Amount_Great__c>acc.Max_Amount__c){
                    con.Amount_Great__c = acc.Max_Amount__c;
                    integer remAmount = Integer.valueOf( totalAmount - acc.Max_Amount__c);
                    do{
                        Contact newCon = new Contact();
                        newCon.LastName = lastName + ' ' + count;
                        if(remAmount > acc.Max_Amount__c){
                        newCon.Amount_Great__c = acc.Max_Amount__c;
                        }
                        else{
                            newCon.Amount_Great__c = remAmount;
                        }
                        newCon.AccountId = con.AccountId;
                        insert newCon;
                        count++;
                        remAmount -= Integer.valueOf( acc.Max_Amount__c);
                    }
                    while(remAmount>acc.Max_Amount__c);
                }
                }
            }
        }
    }
    public static void handleTriggerUpdate(List<Contact> oldCon , List<Contact> newCon){
        for(integer i = 0 ; i<newCon.size(); i++){
            if(newCon[i].Amount_Great__c != oldCon[i].Amount_Great__c && newCon[i].Amount_Great__c !=null){
                if(newCon[i].AccountId != null && oldCon[i].AccountId == newCon[i].AccountId){

                    Account acc = [Select Id, Max_Amount__c from Account where Id = :newCon[i].AccountId];
                    if(acc.Max_Amount__c !=null){
                        integer totalAmount = Integer.valueOf(newCon[i].Amount_Great__c);
                        String lastName = newCon[i].LastName;
                        integer count = 1;
                        if(newCon[i].Amount_Great__c>acc.Max_Amount__c){
                            newCon[i].Amount_Great__c = acc.Max_Amount__c;
                            integer remAmount = Integer.valueOf( totalAmount - acc.Max_Amount__c);
                            while(remAmount>acc.Max_Amount__c)
                            {
                                Contact newCon1 = new Contact();
                                newCon1.LastName = lastName + ' ' + count;
                                if(remAmount > acc.Max_Amount__c){
                                newCon1.Amount_Great__c = acc.Max_Amount__c;
                                }
                                else{
                                    newCon1.Amount_Great__c = remAmount;
                                }
                                newCon1.AccountId = newCon[i].AccountId;
                                insert newCon1;
                                count++;
                                remAmount -= Integer.valueOf( acc.Max_Amount__c);
                            }
                            if(remAmount > 0){
                                Contact newCon1 = new Contact();
                                newCon1.LastName = lastName + ' ' + count;
                                newCon1.Amount_Great__c = remAmount;
                                newCon1.AccountId = newCon[i].AccountId;
                                insert newCon1;
                            }
                            
                        }
                        }
                }
            }
        }
    }
}
public with sharing class RollUpHandler {
    public static void handleTriggerInsert(List<Contact> contacts){
        List<Account> updateAccounts = new List<Account>();
        Map<Id,Decimal> accMap = new Map<Id,Decimal>();
        for(Contact con : contacts){
            if(con.AccountId != null && con.Amount__c!=null){
                if(accMap.containsKey(con.AccountId)){
                    accMap.put(con.AccountId,accMap.get(con.AccountId)+con.Amount__c);
                }else{
                    accMap.put(con.AccountId,con.Amount__c);
                }
            }
        }
        List<Account> accountInfo = [Select Id , Total_Amount__c from Account where Id IN :accMap.keySet()];
        for(Account account : accountInfo){
            if(account.Total_Amount__c == null){
                account.Total_Amount__c = accMap.get(account.Id);
            }
            else{
                account.Total_Amount__c += accMap.get(account.Id);
            }
            updateAccounts.add(account);
        }
        update updateAccounts;
    }
    public static void handleTriggerUpdate(List<Contact> oldContacts , List<Contact> newContacts){
        List<Account> updateAccounts = new List<Account>();
        Map<Id,Decimal> accMap = new Map<Id,Decimal>();
        for(integer i = 0; i<newContacts.size(); i++){
            if(newContacts[i].AccountId != null ){
                if(oldContacts[i].Amount__c != newContacts[i].Amount__c){
                    if(accMap.containsKey(newContacts[i].AccountId)){
                        Decimal totalAmount = 0;
                        if(oldContacts[i].Amount__c != null){
                            totalAmount = accMap.get(newContacts[i].AccountId) - oldContacts[i].Amount__c;
                        }
                        if(newContacts[i].Amount__c != null){
                            totalAmount = accMap.get(newContacts[i].AccountId) + newContacts[i].Amount__c;
                        }
                        accMap.put(newContacts[i].AccountId,totalAmount);   
                    }else{
                        Decimal totalAmount = 0;
                        if(oldContacts[i].Amount__c != null){
                            totalAmount -= oldContacts[i].Amount__c;
                        }
                        if(newContacts[i].Amount__c != null){
                            totalAmount +=  newContacts[i].Amount__c;
                        }
                        accMap.put(newContacts[i].AccountId,totalAmount);
                    }
            //         Account acc = [Select Id,Total_Amount__c from Account where Id =: newContacts[i].AccountId];
            //         if(acc.Total_Amount__c==null){
            //             acc.Total_Amount__c = 0;
            //             acc.Total_Amount__c += newContacts[i].Amount__c;
            //             updateAccounts.add(acc);
            //             continue;
            //         }
            //         if(oldContacts[i].Amount__c != null){
            //             acc.Total_Amount__c -=  oldContacts[i].Amount__c;
            //         }
            //         if(newContacts[i].Amount__c != null){
            //             acc.Total_Amount__c += newContacts[i].Amount__c;
            //         }
            //         updateAccounts.add(acc);
            }
        } 

        List<Account> accountInfo = [Select Id , Total_Amount__c from Account where Id IN :accMap.keySet()];
        for(Account account : accountInfo){
            if(account.Total_Amount__c == null){
                account.Total_Amount__c = accMap.get(account.Id);
            }
            else{
                account.Total_Amount__c += accMap.get(account.Id);
            }
            updateAccounts.add(account);
        }
    }
    update updateAccounts;
    }
    public static void handleTriggerDelete(List<Contact> oldContacts){
        List<Account> newAccounts = new List<Account>();
        Map<Id,Decimal> accMap = new Map<Id,Decimal>();
        for(Contact con : oldContacts){
            if(con.AccountId != null && con.Amount__c!=null){
                if(accMap.containsKey(con.AccountId)){
                    accMap.put(con.AccountId,accMap.get(con.AccountId)+con.Amount__c);
                }else{
                    accMap.put(con.AccountId,con.Amount__c);
                }
            }
        }
        List<Account> accountInfo = [Select Id , Total_Amount__c from Account where Id IN :accMap.keySet()];
        for(Account account : accountInfo){
            if(account.Total_Amount__c == null){
                account.Total_Amount__c = 0;
            }
            account.Total_Amount__c -= accMap.get(account.Id);
            newAccounts.add(account);
        }
        update newAccounts;
    }

}
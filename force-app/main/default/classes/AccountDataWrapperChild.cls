public with sharing class AccountDataWrapperChild {
    @AuraEnabled
    public static AccountDataWrapper getAccounts(){
            AccountDataWrapper wrapper = new AccountDataWrapper();
            wrapper.accounts = [SELECT Id,Name FROM Account];
            return wrapper;
    }
    @AuraEnabled
    public static AccountDataWrapper getConAndOpp(String recordId){
        AccountDataWrapper wrapper = new AccountDataWrapper();
        wrapper.contacts = [SELECT Id,Name FROM Contact WHERE AccountId = :recordId];
        wrapper.opportunities = [SELECT Id,Name FROM Opportunity WHERE AccountId = :recordId];        
        return wrapper;
    }
    public class AccountDataWrapper{
        @AuraEnabled
        public List<Account> accounts {get;set;}
        @AuraEnabled
        public List<Contact> contacts {get;set;}
        @AuraEnabled
        public List<Opportunity> opportunities {get;set;}
    }
}
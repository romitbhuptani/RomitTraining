public with sharing class OppAndConController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(String accId) {
        return [SELECT Id, Name FROM Opportunity where AccountId = :accId];
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accId) {
        return [SELECT Id, Name FROM Contact where AccountId = :accId];
    }
}
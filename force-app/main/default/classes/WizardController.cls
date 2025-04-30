public with sharing class WizardController {
    @AuraEnabled
    public static Id createAccountApex(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc.Id;
    }

    @AuraEnabled
    public static Id createContactApex(String contactName, Id accountId) {
        Contact con = new Contact(LastName = contactName, AccountId = accountId);
        insert con;
        return con.Id;
    }

    @AuraEnabled
    public static void createEventApex(Id contactId) {
        Event evt = new Event(Subject = 'Wizard Task', WhoId = contactId, ActivityDate = Date.today());
        insert evt;
    }
}
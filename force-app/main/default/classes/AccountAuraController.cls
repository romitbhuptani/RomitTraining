public with sharing class AccountAuraController {
    @AuraEnabled
    public static List<Account> getAccounts(String searchTerm) {
        String query = 'SELECT Id, Name FROM Account WHERE Name Like \'%' +String.escapeSingleQuotes(searchTerm)+'%\' ORDER BY NAME';
        List<Account> accounts = Database.query(query);
        System.debug('Accounts: ' + accounts);
        return accounts;
    }

    @AuraEnabled
    public static Map<String, Object> getContacts(Id accountId) {
        Map<String, Object> result = new Map<String, Object>();
        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE AccountId = :accountId];

        result.put('contacts', contacts);
        result.put('contactCount', contactCount);
        return result;
    }

    @AuraEnabled
    public static void updateContactParent(Id contactId, Id newAccountId) {
        Contact con = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
        con.AccountId = newAccountId;
        update con;
    }
}
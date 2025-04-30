global with sharing class deleteRecords {
    webservice static void deleteRecords() {
        List<Account> acc = [SELECT Id FROM Account where Name like '%TestAccount%'];
        List<Contact> con = [SELECT Id FROM Contact where Name like 'TestContact%'];
        delete acc;
        delete con;
    }
}
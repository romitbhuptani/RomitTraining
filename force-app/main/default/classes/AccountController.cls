public with sharing class AccountController {
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(){
        return [Select Id,Name from Account];
    }
}
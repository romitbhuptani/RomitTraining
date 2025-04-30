public with sharing class LazyLoadingController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer limitSize, Integer offset , String sortBy , String sortOrder , String nameLike){
        String query = 'SELECT Id,Name FROM Account WHERE Name LIKE \'%'+nameLike+'%\' ORDER BY  '+sortBy + ' ' + sortOrder + ' LIMIT ' + limitSize +  'OFFSET '+offset;
        List<Account> accountList = Database.query(query);
        return accountList;
    }
    @AuraEnabled(cacheable=true)
    public static Integer getAccountCount(){
        List<Account> accountCount = [SELECT Name FROM Account];
        return accountCount.size();
    }
    @AuraEnabled(cacheable=true)
    public static Integer getNameAccounts(String nameLike){
        String query = 'SELECT Id,Name FROM Account WHERE Name LIKE \'%'+nameLike+'%\'';
        List<Account> accountList = Database.query(query);
        System.debug(accountList);
        return accountList.size();
    }
}
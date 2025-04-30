trigger Trigger12 on Account (before insert) {
    for(Account acc :Trigger.New){
        List<Account> delAccounts = [SELECT Id FROM Account WHERE Name = :acc.Name];
        delete delAccounts;
    }
}
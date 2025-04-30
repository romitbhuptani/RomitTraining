public class BatchTask1 implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, AccountId, Name FROM Opportunity WHERE AccountId != null');
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        Map<Id, Opportunity> uniqueAccountMap = new Map<Id, Opportunity>();
        
        for (Opportunity opp : (List<Opportunity>) scope) {
            if (!uniqueAccountMap.containsKey(opp.AccountId)) {
                uniqueAccountMap.put(opp.AccountId, opp);
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : uniqueAccountMap.keySet()) {
            Opportunity opp = uniqueAccountMap.get(accountId);
            accountsToUpdate.add(new Account(Id = accountId, Name = opp.Name));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished');
    }
   
}
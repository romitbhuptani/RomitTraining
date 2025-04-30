public class BatchTask2 implements Database.Batchable<SObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        String currentDateTime = String.valueOf(Datetime.now());
        for (Account acc : (List<Account>) scope) {
            acc.Description = currentDateTime;
            accountsToUpdate.add(acc);
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished');
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchTask2());
    }
}
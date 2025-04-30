public class WorkBenchApex implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Batch Job started.');
        return Database.getQueryLocator('SELECT Id FROM Account');
    }
    
    public void execute(Database.BatchableContext bc , List<SObject> objects) {
        List<Account> accList = new List<Account>();
        for(integer i = 0 ; i< 200 ; i++){
        Account acc = new Account(Name = 'Workbench'+i);
        accList.add(acc);
        }
        insert accList;
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch job finished');
    }
   
}
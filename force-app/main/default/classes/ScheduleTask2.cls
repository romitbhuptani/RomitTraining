public with sharing class ScheduleTask2 implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Account> accounts = [Select Id from Account];
        for(Account account : accounts){
            account.Rating = 'Warm';
            update account;
        }
    }
}
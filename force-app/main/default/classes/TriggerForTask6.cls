public with sharing class TriggerForTask6 {
    public static void TriggerAfterInsert(Opportunity opp){
      
            Task singleTask = new Task();
            singleTask.OwnerId = opp.OwnerId;
            singleTask.Subject = 'Create contract for opportunity ' + opp.Name;
            singleTask.Status = 'Not Started';
            singleTask.WhatId = opp.Id;
            singleTask.ActivityDate = System.today()+7;
            insert singleTask;
    }
}
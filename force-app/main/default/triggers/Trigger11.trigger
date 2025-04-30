trigger Trigger11 on Contact (after insert) {
    for(Contact con : Trigger.New){
        Event ev = new Event(Subject = 'TriggerAutoEvent',StartDateTime = System.Today(),EndDateTime = System.Today()+1,WhoId = con.Id , OwnerId = con.OwnerId);
        insert ev;
    }
}
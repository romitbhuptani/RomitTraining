trigger Trigger3 on Opportunity (before update) {
    for(Opportunity opp : Trigger.New){
        opp.StageName = 'Prospecting';
        opp.CloseDate = Date.today() + 15;
    }
}
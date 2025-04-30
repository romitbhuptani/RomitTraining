public with sharing class ScheduleTask1 implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Opportunity> newOpps = new List<Opportunity>();
        for(integer i = 1; i <11 ; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'testOppForSchedule'+i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = system.today();
            newOpps.add(opp);
        }
        insert newOpps;
    }
}
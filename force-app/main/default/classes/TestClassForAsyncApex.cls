@isTest
public class TestClassForAsyncApex {
    @isTest
    static void testBatchTask1() {
        
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName = 'Prospecting', CloseDate = Date.today());
        insert opp;

        Test.startTest();
        Database.executeBatch(new BatchTask1(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Test Opportunity', updatedAcc.Name);
    }

    @isTest
    static void testBatchTask2() {

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        Database.executeBatch(new BatchTask2(), 1);
        Test.stopTest();

        Account updatedAcc = [SELECT Description FROM Account WHERE Id = :acc.Id];
        System.assertEquals(String.valueOf(Datetime.now()), updatedAcc.Description , 'Description not updated.');
    }


    @isTest
    static void testScheduleTask1() {
        Test.startTest();
        ScheduleTask1 task = new ScheduleTask1();
        task.execute(null);

        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Name LIKE 'testOppForSchedule%'];
        System.assertEquals(10, opps.size());
        Test.stopTest();
    }

    @isTest
    static void testScheduleTask2() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Test.startTest();
        ScheduleTask2 task = new ScheduleTask2();
        task.execute(null);
        Test.stopTest();

        Account updatedAcc = [SELECT Rating FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Warm', updatedAcc.Rating);
    }
}
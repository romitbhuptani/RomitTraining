@isTest
private class TestClassForTriggers {

    @isTest
    static void testLeadRatingAssignment() {
        Test.startTest();
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'User',
            Company = 'Test Company'
        );
        insert testLead;
        Lead insertedLead = [SELECT Id, Rating FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Hot', insertedLead.Rating, 'The Rating field should be set to "Hot"');
        Test.stopTest();
    }

    @isTest
    static void testForOppStage() {
        Test.startTest();
        Opportunity opp = new Opportunity(Name = 'TestOpportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;
        opp.Email__c = 'test@example.com';
        update opp;
        Opportunity newOpp = [Select Id, StageName, CloseDate from Opportunity where Id = :opp.Id];
        System.assertEquals('Prospecting', newOpp.StageName, 'The StageName field should be set to "Prospecting"');
        System.assertEquals(Date.today() + 15, newOpp.CloseDate, 'The CloseDate field should be set to 15 days from today');
        Test.stopTest();
    }

    @isTest
    static void testForOppType() {
        Test.startTest();
        Opportunity opp = new Opportunity(Name = 'TestOpportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;
        Opportunity newOpp = [Select Id, Type from Opportunity where Id = :opp.Id];
        System.assertEquals('New Customer', newOpp.Type, 'The Type field should be set to "New Customer"');
        Test.stopTest();
    }

    @isTest
    static void testForEmailSent() {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Test.startTest();
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Contact con = new Contact(FirstName = 'Test', LastName = 'User', AccountId = acc.Id , Email = 'test@gmail.com');
        insert con;
        acc.Name = 'TestAccountUpdated';
        update acc;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {con.Email});
        email.setSubject('Test Email');
        email.setPlainTextBody('This is a test email.');
        emails.add(email);
        List<Messaging.SendEmailResult> messages = Messaging.sendEmail(emails);
        System.assertEquals(1, messages.size(), 'An email should be sent when an Account Name is updated');
        Test.stopTest();
    }

    @isTest
    static void testForTaskCreation() {
        Test.startTest();
        Opportunity opp = new Opportunity(Name = 'TestOpp', StageName = 'Prospecting', CloseDate = Date.today());
        insert opp;
        opp.Name = 'TestOpp1';
        update opp;
        List<Task> task = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, task.size(), 'Task subject should be "Create contract for opportunity TestOpp1"');
        Test.stopTest();
    }

    @isTest
    static void testForPrefix() {
        Test.startTest();
        String name = 'TestAccount';
        Account acc = new Account(Name = name);
        insert acc;
        Account accCreated = [Select Id, Name from Account where Id = :acc.Id];
        System.assertEquals('Mr. / Mrs. ' + name, accCreated.Name, 'Mr or Mrs should be appended before name');
        Test.stopTest();
    }

    @isTest
    static void testForDeleteContact() {
        Test.startTest();
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Contact con = new Contact(LastName = 'TestContact', AccountId = acc.Id);
        insert con;
        Boolean isAccountNull = true;
        if(con.AccountId != null){
            isAccountNull = false;
        }
        delete con;
        if(!isAccountNull){
            List<Account> account = [Select Id from Account where Id = :acc.Id];
            System.assertEquals(0, account.size(), 'Account should be deleted when deleting its contact');
        }
        Test.stopTest();
    }

    @isTest
    static void testForApprovalSubmission() {
        Test.startTest();
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<ProcessInstance> targetId = [Select TargetObjectId from ProcessInstance where TargetObjectId = :acc.Id LIMIT 1];
        System.assertEquals(1, targetId.size(), 'Expected 1 approval process to be submitted');
        Test.stopTest();
    }

    @isTest
    static void testForAccAndConCreation() {
        Test.startTest();
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Account accData = [Select Name From Account where Id = :acc.Id];
        List<Contact> con = [Select Id, LastName from Contact where AccountId = :acc.Id and LastName = :accData.Name];
        System.assertEquals(1, con.size(), 'Expected 1 contact to be created');
        Test.stopTest();
    }

    @isTest
    static void testForEventCreation() {
        Test.startTest();
        Contact con = new Contact(LastName = 'Test Contact');
        insert con;
        List<Event> event = [Select Id from Event where WhoId = :con.Id Limit 1];
        System.assertEquals(1, event.size(), 'Event Not Created');
        Test.stopTest();
    }

    @isTest
    static void testForDuplicateDelete() {
        Test.startTest();
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Account acc1 = new Account(Name = 'TestAccount');
        insert acc1;
        List<Account> accList = [Select Id from Account where Name = 'Mr. / Mrs. TestAccount'];
        System.assertEquals(1, accList.size(), 'Duplicate Account Created');
        Test.stopTest();
    }

    @isTest
    static void testForObjectShare() {
        Test.startTest();
        Account acc = new Account(Name = 'TestAccount', Rating = 'Warm');
        insert acc;
        acc.Rating = 'Hot';
        update acc;
        User user = [Select Id from User where Name = 'TestMan'];
        List<AccountShare> accShare = [Select Id from AccountShare where UserOrGroupId = :user.Id and AccountId = :acc.Id];
        System.assertEquals(1, accShare.size(), 'AccountShare Not Created');
        Test.stopTest();
    }

    @isTest
    static void testForRollUp() {
        Test.startTest();
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Contact con1 = new Contact(LastName = 'Test Contact1', AccountId = acc.Id, Amount__c = 50);
        insert con1;
        Contact con2 = new Contact(LastName = 'Test Contact2', AccountId = acc.Id, Amount__c = 100);
        insert con2;
        System.assertEquals(150, [Select Total_Amount__c from Account where Id = :acc.Id].Total_Amount__c, 'Amount Not Rolled Up');
        con1.Amount__c = 200;
        update con1;
        System.assertEquals(300, [Select Total_Amount__c from Account where Id = :acc.Id].Total_Amount__c, 'Amount Not Rolled Up');
        delete con1;
        System.assertEquals(100, [Select Total_Amount__c from Account where Id = :acc.Id].Total_Amount__c, 'Amount Not Rolled Up');
        acc.Total_Amount__c = null;
        update acc;
        con2.Amount__c = 300;
        update con2;
        System.assertEquals(300, [Select Total_Amount__c from Account where Id = :acc.Id].Total_Amount__c, 'Amount Not Rolled Up');
        Test.stopTest();
    }

    @isTest
    static void testForSheep() {
        Test.startTest();
        Account acc1 = new Account(Name = 'TestAccount1');
        insert acc1;
        Account acc2 = new Account(Name = 'TestAccount2');
        insert acc2;
        Contact con1 = new Contact(LastName = 'TestContact1', AccountId = acc1.Id);
        insert con1;
        Contact con2 = new Contact(LastName = 'TestContact2', AccountId = acc1.Id);
        insert con2;
        Contact con3 = new Contact(LastName = 'TestContact3', AccountId = acc1.Id);
        insert con3;
        con2.AccountId = acc2.Id;
        update con2;
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc2.Id];
        System.assertEquals(3, contacts.size(), 'Expected 3 contacts');
        Test.stopTest();
    }

    @isTest
    static void testForGreat() {
        Test.startTest();
        Account acc = new Account(Name = 'Test Account', Max_Amount__c = 30);
        insert acc;
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id, Amount_Great__c = 45);
        insert con;
        System.assertEquals(2, [Select Count() from Contact where AccountId = :acc.Id], 'Contact Not Created According to the Amount');

        con.Amount_Great__c = 75;
        update con;

        System.assertEquals(4,[Select Count() from Contact where AccountId = :acc.Id ],'Contact Not Updated According to the Amount');
        Test.stopTest();
    }
}
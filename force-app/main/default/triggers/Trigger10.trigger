trigger Trigger10 on Account (after insert) {
        for(Account acc :Trigger.New){
            Contact con = new Contact(AccountId = acc.Id , LastName = acc.Name);
            insert con;
        }
}
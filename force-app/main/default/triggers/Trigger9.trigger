trigger Trigger9 on Account (after insert) {
    for(Account acc :Trigger.New){
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval automatically using Trigger');
        req1.setObjectId(acc.id);
        Approval.ProcessResult result = Approval.process(req1);
    }
}
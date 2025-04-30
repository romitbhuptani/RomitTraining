trigger Trigger13 on Account (after update) {
    List<Account> newAcc = Trigger.New;
    List<Account> oldAcc = Trigger.Old;
    for (integer i = 0; i < newAcc.size(); i++) {
        if (newAcc[i].Rating != oldAcc[i].rating && newAcc[i].Rating == 'Hot') {
            AccountShare share = new AccountShare();
            share.AccountId = newAcc[i].Id;
            User user = [Select Id from User where Name = 'TestMan'];
            share.UserOrGroupId = user.Id;
            share.AccountAccessLevel = 'Edit';
            share.OpportunityAccessLevel = 'Read';
            insert share;
        }

    }
}
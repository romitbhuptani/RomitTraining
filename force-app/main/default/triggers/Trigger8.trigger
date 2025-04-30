trigger Trigger8 on Contact (after delete) {
    for(Contact con : Trigger.Old){
        Account acc = new Account();
        if(con.AccountId!=null){
            acc.Id = con.AccountId;
            delete acc;
        }
        
    }
}
global with sharing class CreateAccount {
    webservice static void makeAccount() {
        for(integer i = 1 ; i<=10 ; i++){
            Account acc = new Account(Name = 'TestAccount'+i);
            insert acc;
        }
        
    }
}
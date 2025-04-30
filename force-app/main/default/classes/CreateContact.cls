global with sharing class CreateContact {
    webservice static void makeContact() {
        for(integer i = 1 ; i<=10 ; i++){
            Contact con = new Contact(LastName = 'TestContact'+i);
            insert con;
        }
    }
}
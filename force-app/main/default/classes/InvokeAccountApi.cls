public with sharing class InvokeAccountApi {
    public static void callCreateAccount(){
        soapSforceComSchemasClassCreateacco.CreateAccount createAccountService = new soapSforceComSchemasClassCreateacco.CreateAccount();

        
        createAccountService.SessionHeader = new soapSforceComSchemasClassCreateacco.SessionHeader_element();
        createAccountService.SessionHeader.sessionId = UserInfo.getSessionId();
        createAccountService.endpoint_x = 'https://ind136.sfdc-y37hzm.salesforce.com/services/Soap/class/CreateAccount';


        createAccountService.makeAccount();
            
    }
}
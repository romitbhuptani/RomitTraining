public with sharing class InvokeContactApi {
    public static void callCreateContact() {
        soapSforceComSchemasClassCreatecont.CreateContact createContactService = new soapSforceComSchemasClassCreatecont.CreateContact();

        
        createContactService.SessionHeader = new soapSforceComSchemasClassCreatecont.SessionHeader_element();
        createContactService.SessionHeader.sessionId = UserInfo.getSessionId();
        createContactService.endpoint_x = 'https://ind136.sfdc-y37hzm.salesforce.com/services/Soap/class/CreateContact';

    
        createContactService.makeContact();
            
    }
}
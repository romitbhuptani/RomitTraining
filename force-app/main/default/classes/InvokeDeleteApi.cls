public with sharing class InvokeDeleteApi {
    public static void callDeleteRecords() {
        soapSforceComSchemasClassDeletereco.deleteRecords deleteService = new soapSforceComSchemasClassDeletereco.deleteRecords();

        
        deleteService.SessionHeader = new soapSforceComSchemasClassDeletereco.SessionHeader_element();
        deleteService.SessionHeader.sessionId = UserInfo.getSessionId();
        deleteService.endpoint_x = 'https://ind136.sfdc-y37hzm.salesforce.com/services/Soap/class/deleteRecords';

        
        deleteService.deleteRecords();
        
    }
}
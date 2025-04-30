public with sharing class ErrorLogs {
    public ErrorLogs(Exception exc) {
        Error_Log__c err = new Error_Log__c();
        err.Class_Name__c = String.valueOf(exc.getCause());
        err.Exception_Message__c = exc.getMessage();
        err.Line_Number__c = exc.getLineNumber();
        err.Method_Name__c = exc.getStackTraceString();
        err.Exception_Type__c = exc.getTypeName();
        err.More_Details__c = 'This is custom error message.';
    }
}
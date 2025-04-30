public class ContactAuraController {
    @AuraEnabled
public static ContactDataTableWrapper getContactData(String recordId, Integer pageNumber, Integer pageSize, String searchKey) {
    Integer offset = (pageNumber - 1) * pageSize;

    String countQuery = 'SELECT COUNT() FROM Contact WHERE AccountId = \'' + String.escapeSingleQuotes(recordId) + '\'';
    if (!String.isEmpty(searchKey)) {
        countQuery += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
    }
    
    Integer totalRecords = (Integer) Database.countQuery(countQuery);
    Integer recordEnd = pageSize * pageNumber;

    ContactDataTableWrapper objDT = new ContactDataTableWrapper();
    objDT.pageSize = pageSize;
    objDT.pageNumber = pageNumber;
    objDT.recordStart = totalRecords > 0 ? offset + 1 : 0; 
    objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
    objDT.totalRecords = totalRecords;

    String query = 'SELECT Id, Name, Phone, Email FROM Contact WHERE AccountId = \'' + String.escapeSingleQuotes(recordId) + '\'';
    if (!String.isEmpty(searchKey)) {
        query += ' AND Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
    }
    query += ' ORDER BY Name LIMIT ' + pageSize + ' OFFSET ' + offset;

    objDT.contactList = Database.query(query);
    return objDT;
}

     
    public class ContactDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Contact> contactList {get;set;}
    }
}
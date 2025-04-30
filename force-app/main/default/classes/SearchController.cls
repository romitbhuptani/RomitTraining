public with sharing class SearchController {
    @AuraEnabled
    public static Map<String, List<sObject>> searchRecords(String searchTerm, List<String> objectNames) {

        Map<String, List<sObject>> searchResults = new Map<String, List<sObject>>();

        String soslQuery = 'FIND \'' + String.escapeSingleQuotes(searchTerm) + '*\' IN ALL FIELDS RETURNING ';
        List<String> objectQueries = new List<String>();

        for (String objectName : objectNames) {
            objectQueries.add(objectName + '(Id, Name)');
        }
        
        soslQuery += String.join(objectQueries, ', ');

        List<List<sObject>> results = Search.query(soslQuery);

        for (Integer i = 0; i < results.size(); i++) {
            searchResults.put(objectNames[i], results[i]);
        }

        return searchResults;
    }
}
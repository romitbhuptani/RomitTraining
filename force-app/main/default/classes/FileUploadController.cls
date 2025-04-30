public with sharing class FileUploadController {
    @AuraEnabled
    public static List<ContentDocumentLink> getFiles(Id recordId) {
        return [
            SELECT ContentDocumentId, ContentDocument.Title, Id
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
            ORDER BY ContentDocument.Title
        ];
    }
}
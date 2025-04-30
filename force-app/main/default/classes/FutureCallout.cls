public with sharing class FutureCallout {
    @AuraEnabled
    @future(callout=true)
    public static void addRandomFile(String oppId) {
        String apiUrl = 'https://api.unsplash.com/photos/random/?client_id=Dt1cwi50N_N9osCVdIlipmihBx6cMh1wkilJRl0FPBw';
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(apiUrl);
        
        HttpResponse httpResponse = http.send(httpRequest);
        if(httpResponse.getStatusCode() == 200) {
            Map<String , Object> responseBody = (Map<String , Object>) JSON.deserializeUntyped(httpResponse.getBody()); 
            
            Map<String,Object> imageUrlObj = (Map<String , Object>) responseBody.get('urls');
            String imageUrl = (String) imageUrlObj.get('full');
            HttpRequest imageRequest = new HttpRequest();
            imageRequest.setEndpoint(imageUrl);
            imageRequest.setMethod('GET');
            HttpResponse imageResponse = http.send(imageRequest);
            if(imageResponse.getStatusCode() == 200){
                Blob imageBlob = imageResponse.getBodyAsBlob();
                ContentVersion contentVersion = new ContentVersion();
                contentVersion.title = 'Random Image';
                contentVersion.PathOnClient = 'image.jpg';
                contentVersion.VersionData = imageBlob;
                insert contentVersion;
                
                ContentDocumentLink contentLink = new ContentDocumentLink();
                contentLink.ContentDocumentId = [SELECT  ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;
                contentLink.LinkedEntityId = oppId;
                insert contentLink;
            
        }
        }
    }
}
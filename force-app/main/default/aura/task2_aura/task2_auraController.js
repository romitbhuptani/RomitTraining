({
    doInit: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var recordId = component.get("v.recordId");
        var searchKey = component.find("search").get("v.value");
        helper.getContactList(component, recordId , pageNumber, pageSize , searchKey);
    },
    
    searchChange: function(component, event, helper) {
        var pageSize = component.find("pageSize").get("v.value"); 
        var recordId = component.get("v.recordId");
        var searchKey = component.find("search").get("v.value");
        component.set("v.PageNumber", 1);
        helper.getContactList(component, recordId, 1, pageSize, searchKey);
    }
    ,
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var recordId = component.get("v.recordId");
        var searchKey = component.find("search").get("v.value");
        pageNumber++;
        helper.getContactList(component, recordId ,  pageNumber, pageSize , searchKey);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var recordId = component.get("v.recordId");
        var searchKey = component.find("search").get("v.value");
        pageNumber--;
        helper.getContactList(component, recordId ,  pageNumber, pageSize , searchKey);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        var recordId = component.get("v.recordId");
        var searchKey = component.find("search").get("v.value");
        helper.getContactList(component, recordId ,  page, pageSize , searchKey);
    },
})
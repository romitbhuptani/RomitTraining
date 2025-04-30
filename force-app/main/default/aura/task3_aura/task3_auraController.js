({
    doInit: function(component, event, helper) {
        console.log('doInit');
        
        helper.fetchAccounts(component, "", "accountList1");
        helper.fetchAccounts(component, "", "accountList2");
    },
    searchAccounts1: function(component, event, helper) {
        console.log('searchAccounts1');
        
        var searchKey1 = component.find("search1").get("v.value");
    
        helper.fetchAccounts(component, searchKey1,"accountList1");
    },


    searchAccounts2: function(component, event, helper) {
        var searchKey2 = component.find("search2").get("v.value");
        helper.fetchAccounts(component, searchKey2 , "accountList2");
    },

    loadContacts1: function(component, event, helper) {
        helper.fetchContacts(component, "selectedAccount1", "contacts1", "contactCount1");
    },

    loadContacts2: function(component, event, helper) {
        helper.fetchContacts(component, "selectedAccount2", "contacts2", "contactCount2");
    },

    handleDrag: function(component, event) {
        event.dataTransfer.setData("contactId", event.target.dataset.id);
    },

    allowDrop: function(component, event) {
        event.preventDefault();
    },

    handleDrop1: function(component, event, helper) {
        event.preventDefault();
        var contactId = event.dataTransfer.getData("contactId");
        var accountId = component.get("v.selectedAccount1");
        helper.updateContactAccount(component, contactId, accountId, "contacts1", "contactCount1");
    },

    handleDrop2: function(component, event, helper) {
        event.preventDefault();
        var contactId = event.dataTransfer.getData("contactId");
        var accountId = component.get("v.selectedAccount2");
        helper.updateContactAccount(component, contactId, accountId, "contacts2", "contactCount2");
    }
});
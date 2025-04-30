({
    doInit: function(component, event, helper) {
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var accounts = response.getReturnValue().accounts.map(acc => ({ label: acc.Name, value: acc.Id }));
                component.set("v.accountList" , accounts);
            }
        });
        $A.enqueueAction(action);
    },
    loadContactsAndOpportunities: function(component, event, helper){
        var accountId = component.get("v.selectedAccount");
        var action = component.get("c.getConAndOpp");
        action.setParams({
            "recordId" : accountId
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var contacts = response.getReturnValue().contacts;
                component.set("v.contacts", contacts);
                var opportunities = response.getReturnValue().opportunities;
                component.set("v.opportunities", opportunities);
            }
        });
    
        $A.enqueueAction(action);
    }


})
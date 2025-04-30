({
    fetchAccounts: function(component, searchKey ,attributeName) {
        var action = component.get("c.getAccounts");
        action.setParams({ searchTerm: searchKey });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var accounts = response.getReturnValue().map(acc => ({ label: acc.Name, value: acc.Id }));
                component.set("v." + attributeName, accounts);
            }
        });
        $A.enqueueAction(action);
    },

    fetchContacts: function(component, accountAttribute, contactAttribute, countAttribute) {
        var accountId = component.get("v." + accountAttribute);
        var action = component.get("c.getContacts");
        action.setParams({ accountId: accountId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v." + contactAttribute, data.contacts);
                component.set("v." + countAttribute, data.contactCount);
            }
        });
        $A.enqueueAction(action);
    },

    updateContactAccount: function(component, contactId, newAccountId, contactAttribute, countAttribute) {
        var action = component.get("c.updateContactParent");
        action.setParams({ contactId: contactId, newAccountId: newAccountId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                this.fetchContacts(component, "selectedAccount1", "contacts1", "contactCount1");
                this.fetchContacts(component, "selectedAccount2", "contacts2", "contactCount2");
            }
        });
        $A.enqueueAction(action);
    }
});
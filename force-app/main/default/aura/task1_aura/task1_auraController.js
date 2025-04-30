({
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Record has been created successfully',
            duration:' 5000',
            type: 'success',
        });
        toastEvent.fire();
    }
})
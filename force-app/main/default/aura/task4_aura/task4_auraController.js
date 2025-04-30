({
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");
        pageNumber++;
        component.set("v.CurrentStep", pageNumber.toString());
        component.set("v.PageNumber", pageNumber);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        pageNumber--;
        component.set("v.CurrentStep", pageNumber.toString());
        component.set("v.PageNumber", pageNumber);
    },
})
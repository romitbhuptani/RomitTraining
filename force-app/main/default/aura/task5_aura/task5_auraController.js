({
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");
        var currentStep = component.get("v.CurrentStep");
        currentStep += 25;
        pageNumber++;
        component.set("v.CurrentStep", currentStep);
        component.set("v.PageNumber", pageNumber);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var currentStep = component.get("v.CurrentStep");
        currentStep -= 25;
        pageNumber--;
        component.set("v.CurrentStep", currentStep);
        component.set("v.PageNumber", pageNumber);
    },
})
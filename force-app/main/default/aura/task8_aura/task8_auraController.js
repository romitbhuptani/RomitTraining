({
    handleImageUpload: function(component, event, helper) {
        var imageData = event.getParam("imageData");
        component.set("v.imageData", imageData);
    }
})
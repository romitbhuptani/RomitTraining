({
    handleFileChange: function(component, event, helper) {
        var file = event.getSource().get("v.files")[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var base64Image = e.target.result;
                var compEvent = component.getEvent("onImageUpload");
                compEvent.setParams({ "imageData": base64Image });
                compEvent.fire();
            };
            reader.readAsDataURL(file);
        }
    }
})
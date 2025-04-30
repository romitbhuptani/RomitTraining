({
    handleImageChange  : function(component, event, helper) {
        var imageUrl = component.get("v.imageUrl");
        var newMapAttributes = {"src": imageUrl};
        component.find("imgDiv").set("v.HTMLAttributes",newMapAttributes);
    }
    ,
    handleBackgroundChange  : function(component, event, helper){
        var backgroundColor = component.get("v.backgroundColor");
        component.set("v.backgroundColor", backgroundColor);
    },

    handleDescriptionChange  : function(component, event, helper){
        var description = component.get("v.description");
        component.set("v.description", description);
    },

    handleFontColorChange  : function(component, event, helper){
        var fontColor = component.get("v.fontColor");
        component.set("v.fontColor", fontColor);
    },

    handleFontSizeChange  : function(component, event, helper){
        var fontSize = component.get("v.fontSize");
        component.set("v.fontSize", fontSize);
    }

})
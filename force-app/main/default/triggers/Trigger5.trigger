trigger Trigger5 on Account (before update) {
    Set<Id> updatedAccountIds = new Set<Id>();
    for (Integer i = 0; i < Trigger.old.size(); i++) {
        if (Trigger.old[i].Name != Trigger.new[i].Name) {
            updatedAccountIds.add(Trigger.new[i].Id);
        }
    }

    List<Contact> relatedContacts = [SELECT Id,Name, Email FROM Contact WHERE AccountId IN :updatedAccountIds AND Email != NULL];

    EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE Name = : 'ContactUpdate' ];

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    for (Contact c : relatedContacts) {
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        System.debug(c.Name);
        singleMail.setTargetObjectId(c.Id);
        singleMail.setTemplateId(et.Id);
        singleMail.setSaveAsActivity(false);
        emails.add(singleMail);
    }

    if (!emails.isEmpty()) {
        System.debug(emails);
        Messaging.sendEmail(emails);
    }
}
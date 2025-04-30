public without sharing class CommunityRegistrationController {
    private static final String CONTACT_NOT_FOUND = 'No contact found for the provided email address.';

    @AuraEnabled
    public static String registerUser(String userData) {
        try {
            // Parse JSON data
            Map<String, Object> userMap = (Map<String, Object>) JSON.deserializeUntyped(userData);
            String firstName = (String) userMap.get('firstName');
            String lastName = (String) userMap.get('lastName');
            String email = (String) userMap.get('email');
            String password = (String) userMap.get('password');
            String role = (String) userMap.get('role');
            String department = (String) userMap.get('department');
            String gradeLevel = (String) userMap.get('gradeLevel');

            // Validate input
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email) || String.isBlank(role) || String.isBlank(password)) {
                throw new AuraHandledException('All required fields must be filled.');
            }

            // Find or create an Account
            Account portalAccount = [SELECT Id, OwnerId, Owner.UserRoleId 
                                   FROM Account 
                                   WHERE Name = 'Burlington Textiles Weaving Plant Generator' 
                                   LIMIT 1];

            // Validate account owner has a role
            if (portalAccount.Owner.UserRoleId == null) {
                throw new AuraHandledException('Account owner must have a role assigned. Owner ID: ' + portalAccount.OwnerId);
            }
            System.debug('Portal Account Owner Role ID: ' + portalAccount.Owner.UserRoleId);

            // Create or find Contact
            Contact contact;
            List<Contact> contacts = [SELECT Id, AccountId 
                                    FROM Contact 
                                    WHERE AccountId = :portalAccount.Id 
                                    AND Email = :email 
                                    ORDER BY CreatedDate 
                                    LIMIT 1];
            if (contacts.isEmpty()) {
                contact = new Contact(
                    FirstName = firstName,
                    LastName = lastName,
                    Email = email,
                    AccountId = portalAccount.Id
                );
                insert contact;
            } else {
                contact = contacts[0];
            }

            // Create Community User record
            Community_User__c communityUser = new Community_User__c(
                First_Name__c = firstName,
                Last_Name__c = lastName,
                Email__c = email,
                Role__c = role,
                Department__c = department,
                Grade_Level__c = gradeLevel,
                Account__c = portalAccount.Id,
                Contact__c = contact.Id,
                Password__c = password,
                Registration_Status__c = 'Completed'
            );

            insert communityUser;

            // Send welcome email
            sendWelcomeEmail(firstName, lastName, email, role);

            return 'Community user registered successfully';
        } catch (Exception e) {
            System.debug('Error registering community user: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            throw new AuraHandledException('Error registering community user: ' + e.getMessage());
        }
    }

    private static void sendWelcomeEmail(String firstName, String lastName, String email, String role) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { email });
            mail.setSubject('Welcome to Our Community!');
            mail.setSenderDisplayName('Community Support Team');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);

            // Customize email body
            String emailBody = 'Dear ' + firstName + ' ' + lastName + ',\n\n';
            emailBody += 'Welcome to our Community! We are excited to have you join us as a ' + role + '.\n';
            emailBody += 'Your registration has been successfully completed.\n\n';
            emailBody += 'To get started, please visit our community portal\n';
            emailBody += 'If you have any questions, feel free to contact our support team at support@community.com.\n\n';
            emailBody += 'Best regards,\nThe Community Support Team';

            mail.setPlainTextBody(emailBody);

            // Send the email
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if (results[0].isSuccess()) {
                System.debug('Welcome email sent successfully to: ' + email);
            } else {
                System.debug('Failed to send welcome email: ' + results[0].getErrors()[0].getMessage());
            }
        } catch (Exception e) {
            System.debug('Error sending welcome email: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            // Log error but don't throw to avoid rolling back the transaction
        }
    }
}
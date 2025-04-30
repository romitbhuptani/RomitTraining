public without sharing class CommunityForgotPasswordController {
    private static final Integer OTP_LENGTH = 6;
    private static final Integer OTP_VALIDITY_MINUTES = 10;

    // Send OTP to the user's email
    @AuraEnabled
    public static String sendOtp(String email) {
        try {
            if (String.isBlank(email)) {
                return JSON.serialize(new Result(false, 'Email is required.'));
            }

            // Validate email format
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern emailPattern = Pattern.compile(emailRegex);
            if (!emailPattern.matcher(email).matches()) {
                return JSON.serialize(new Result(false, 'Please enter a valid email address.'));
            }

            // Query Community_User__c
            List<Community_User__c> users = [SELECT Id, First_Name__c, Last_Name__c, Email__c, Contact__c 
                                            FROM Community_User__c 
                                            WHERE Email__c = :email 
                                            LIMIT 1];
            if (users.isEmpty()) {
                return JSON.serialize(new Result(false, 'No user found with this email address.'));
            }

            // Get the user
            User us = [SELECT Id, FirstName, LastName, Email FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug('User: ' + us);

            Community_User__c user = users[0];

            // Generate OTP
            String otp = generateOtp();

            // Get Email Template
            EmailTemplate template = [SELECT Id, Body FROM EmailTemplate WHERE DeveloperName = 'Community_Forgot_Password_Email' LIMIT 1];
            System.debug('Email Template: ' + template);
            // Prepare email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            System.debug('Mail send to: ' + email);
            mail.setSubject('Your OTP for Password Reset');
            mail.setToAddresses(new String[] { email });
            mail.setTemplateId(template.Id);
            mail.setTargetObjectId(user.Contact__c); // Use Contact for standard merge fields (if needed)
            mail.setWhatId(user.Id); // Associates with Community_User__c for custom field merging
            mail.setSaveAsActivity(false);

            // Manually replace {OTP} in the template body
            String emailBody = template.Body;
            emailBody = emailBody.replace('{OTP}', otp);
            emailBody = emailBody.replace('{FirstName}', user.First_Name__c);
            emailBody = emailBody.replace('{LastName}', user.Last_Name__c);
            System.debug('Email Body: ' + emailBody);
            mail.setPlainTextBody(emailBody);
            System.debug('Mail Body: ' + mail.getPlainTextBody());
            // Send email
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('Email send result: ' + results[0]);
            if (!results[0].isSuccess()) {
                System.debug('Failed to send OTP email: ' + results[0].getErrors()[0].getMessage());
                return JSON.serialize(new Result(false, 'Failed to send OTP email. Please try again.'));
            }

            // Return OTP to LWC (not stored)
            return JSON.serialize(new Result(true, 'OTP sent to your email.', otp));
        } catch (Exception e) {
            System.debug('Error sending OTP: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            return JSON.serialize(new Result(false, 'An error occurred: ' + e.getMessage()));
        }
    }

    // Update password after OTP validation
    @AuraEnabled
    public static String updatePassword(String email, String otp, String providedOtp, String newPassword, String confirmPassword) {
        try {
            if (String.isBlank(email) || String.isBlank(otp) || String.isBlank(providedOtp) || String.isBlank(newPassword) || String.isBlank(confirmPassword)) {
                return JSON.serialize(new Result(false, 'All fields are required.'));
            }

            // Validate OTP
            if (otp != providedOtp) {
                return JSON.serialize(new Result(false, 'Invalid OTP.'));
            }

            // Validate password match
            if (newPassword != confirmPassword) {
                return JSON.serialize(new Result(false, 'Passwords do not match.'));
            }

            // Validate password strength
            String passwordRegex = '^(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$';
            Pattern passwordPattern = Pattern.compile(passwordRegex);
            if (!passwordPattern.matcher(newPassword).matches()) {
                return JSON.serialize(new Result(false, 'Password must be at least 8 characters long, contain at least one digit, and one special character.'));
            }

            // Query Community_User__c
            List<Community_User__c> users = [SELECT Id, Password__c 
                                            FROM Community_User__c 
                                            WHERE Email__c = :email 
                                            LIMIT 1];
            if (users.isEmpty()) {
                return JSON.serialize(new Result(false, 'No user found with this email address.'));
            }

            // Update password
            Community_User__c user = users[0];
            user.Password__c = newPassword;
            update user;

            return JSON.serialize(new Result(true, 'Password updated successfully.'));
        } catch (Exception e) {
            System.debug('Error updating password: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            return JSON.serialize(new Result(false, 'An error occurred: ' + e.getMessage()));
        }
    }

    // Generate a random OTP
    private static String generateOtp() {
        String chars = '0123456789';
        String otp = '';
        for (Integer i = 0; i < OTP_LENGTH; i++) {
            Integer index = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            otp += chars.substring(index, index + 1);
        }
        return otp;
    }

    // Inner class for response
    public class Result {
        public Boolean success;
        public String message;
        public String otp;

        public Result(Boolean success, String message) {
            this.success = success;
            this.message = message;
            this.otp = null;
        }

        public Result(Boolean success, String message, String otp) {
            this.success = success;
            this.message = message;
            this.otp = otp;
        }
    }
}
public without sharing class CommunityResetPasswordController {
    // Update the user's password based on email
    @AuraEnabled
    public static String updatePassword(String email, String newPassword, String confirmPassword) {
        try {
            if (String.isBlank(email) || String.isBlank(newPassword) || String.isBlank(confirmPassword)) {
                return JSON.serialize(new Result(false, 'All fields are required.'));
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

            System.debug('Updating password for email: ' + email);
            // Query Community_User__c
            List<Community_User__c> users = [SELECT Id, Password__c 
                                            FROM Community_User__c 
                                            WHERE Email__c = :email
                                            LIMIT 1];
            if (users.isEmpty()) {
                return JSON.serialize(new Result(false, 'User record not found.'));
            }

            // Update password
            Community_User__c user = users[0];
            user.Password__c = newPassword;
            update user;

            return JSON.serialize(new Result(true, 'Password updated successfully. Please log in again.'));
        } catch (Exception e) {
            System.debug('Error updating password: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            return JSON.serialize(new Result(false, 'An error occurred: ' + e.getMessage()));
        }
    }

    // Inner class for response
    public class Result {
        public Boolean success;
        public String message;

        public Result(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}
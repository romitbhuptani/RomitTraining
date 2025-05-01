public without sharing class CommunityLoginController {
    @AuraEnabled
    public static String loginUser(String email, String password) {
        try {
            // Validate input
            if (String.isBlank(email) || String.isBlank(password)) {
                return JSON.serialize(new LoginResult(false, 'Email and password are required.'));
            }

            // Query Community_User__c for the provided email
            List<Community_User__c> users = [SELECT Id, Email__c, Password__c, Role__c 
                                            FROM Community_User__c 
                                            WHERE Email__c = :email 
                                            LIMIT 1];

            if (users.isEmpty()) {
                return JSON.serialize(new LoginResult(false, 'No user found with this email address.'));
            }

            Community_User__c user = users[0];

            // Compare provided password with stored password
            if (user.Password__c != password) {
                return JSON.serialize(new LoginResult(false, 'Invalid password.'));
            }

            // Validate Role__c
            if (String.isBlank(user.Role__c) || !new Set<String>{'Teacher', 'Student'}.contains(user.Role__c)) {
                return JSON.serialize(new LoginResult(false, 'Invalid user role.'));
            }

            // Successful login
            return JSON.serialize(new LoginResult(true, 'Login successful.', user.Role__c));
        } catch (Exception e) {
            System.debug('Error during login: ' + e.getMessage() + '\nStack Trace: ' + e.getStackTraceString());
            return JSON.serialize(new LoginResult(false, 'An error occurred during login: ' + e.getMessage()));
        }
    }

    // Inner class to structure the login response
    public class LoginResult {
        public Boolean success;
        public String message;
        public String role;

        public LoginResult(Boolean success, String message) {
            this.success = success;
            this.message = message;
            this.role = null;
        }

        public LoginResult(Boolean success, String message, String role) {
            this.success = success;
            this.message = message;
            this.role = role;
        }
    }
}
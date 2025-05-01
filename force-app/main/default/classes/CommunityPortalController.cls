public without sharing class CommunityPortalController {
    // Fetch user role based on email
    @AuraEnabled(cacheable=true)
    public static String getUserRole(String email) {
        try {
            if (String.isBlank(email)) {
                throw new AuraHandledException('Email is required.');
            }
            List<Community_User__c> users = [SELECT Role__c FROM Community_User__c WHERE Email__c = :email LIMIT 1];
            if (users.isEmpty()) {
                throw new AuraHandledException('User not found.');
            }
            return users[0].Role__c;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching user role: ' + e.getMessage());
        }
    }

    // Fetch user profile data
    @AuraEnabled(cacheable=true)
    public static Community_User__c getUserProfile(String email) {
        try {
            if (String.isBlank(email)) {
                throw new AuraHandledException('Email is required.');
            }
            List<Community_User__c> users = [SELECT First_Name__c, Last_Name__c, Email__c, Role__c, Department__c, Grade_Level__c 
                                             FROM Community_User__c 
                                             WHERE Email__c = :email LIMIT 1];
            if (users.isEmpty()) {
                throw new AuraHandledException('User not found.');
            }
            return users[0];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching profile: ' + e.getMessage());
        }
    }

    // Update user profile
    @AuraEnabled
    public static String updateUserProfile(String email, String firstName, String lastName, String department, String gradeLevel) {
        try {
            if (String.isBlank(email) || String.isBlank(firstName) || String.isBlank(lastName)) {
                return JSON.serialize(new Result(false, 'First Name, Last Name, and Email are required.'));
            }

            // Validate Email Format
            String emailRegex = '^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$'; // Fixed regex
            Pattern emailPattern = Pattern.compile(emailRegex);
            if (!emailPattern.matcher(email).matches()) {
                return JSON.serialize(new Result(false, 'Please enter a valid email address.'));
            }

            List<Community_User__c> users = [SELECT Id, Role__c, Department__c, Grade_Level__c 
                                             FROM Community_User__c 
                                             WHERE Email__c = :email LIMIT 1];
            if (users.isEmpty()) {
                return JSON.serialize(new Result(false, 'User not found.'));
            }

            Community_User__c user = users[0];
            user.First_Name__c = firstName.trim();
            user.Last_Name__c = lastName.trim();
            user.Email__c = email.trim();
            if (user.Role__c == 'Teacher' && String.isBlank(department)) {
                return JSON.serialize(new Result(false, 'Department cannot be empty for Teachers.'));
            }
            if (user.Role__c == 'Student' && String.isBlank(gradeLevel)) {
                return JSON.serialize(new Result(false, 'Grade Level cannot be empty for Students.'));
            }
            user.Department__c = department != null ? department.trim() : null;
            user.Grade_Level__c = gradeLevel != null ? gradeLevel.trim() : null;

            update user;
            return JSON.serialize(new Result(true, 'Profile updated successfully.'));
        } catch (Exception e) {
            return JSON.serialize(new Result(false, 'Error updating profile: ' + e.getMessage()));
        }
    }

    // Fetch students for a teacher
    @AuraEnabled(cacheable=true)
    public static List<Community_User__c> getStudentsForTeacher(String teacherEmail) {
        try {
            if (String.isBlank(teacherEmail)) {
                throw new AuraHandledException('Teacher email is required.');
            }
            // Query teacher Id first
            List<Community_User__c> teachers = [SELECT Id FROM Community_User__c WHERE Email__c = :teacherEmail AND Role__c = 'Teacher' LIMIT 1];
            if (teachers.isEmpty()) {
                throw new AuraHandledException('Teacher not found.');
            }
            Id teacherId = teachers[0].Id;

            // Query students linked to the teacher
            return [SELECT Id, First_Name__c, Last_Name__c, Email__c, Grade_Level__c 
                    FROM Community_User__c 
                    WHERE Role__c = 'Student' AND Teacher__c = :teacherId];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching students: ' + e.getMessage());
        }
    }

    // Fetch student details
    @AuraEnabled(cacheable=true)
    public static Community_User__c getStudentDetails(String studentId) {
        try {
            if (String.isBlank(studentId)) {
                throw new AuraHandledException('Student ID is required.');
            }
            List<Community_User__c> students = [SELECT First_Name__c, Last_Name__c, Email__c, Grade_Level__c, Teacher__r.First_Name__c, Teacher__r.Last_Name__c 
                                                FROM Community_User__c 
                                                WHERE Id = :studentId AND Role__c = 'Student' LIMIT 1];
            if (students.isEmpty()) {
                throw new AuraHandledException('Student not found.');
            }
            return students[0];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching student details: ' + e.getMessage());
        }
    }

    // Submit feedback
    @AuraEnabled
    public static String submitFeedback(String studentId, String teacherEmail, String emoji, String comment) {
        try {
            if (String.isBlank(studentId) || String.isBlank(teacherEmail) || String.isBlank(emoji)) {
                return JSON.serialize(new Result(false, 'Student, Teacher, and Emoji are required.'));
            }

            List<Community_User__c> teachers = [SELECT Id FROM Community_User__c WHERE Email__c = :teacherEmail AND Role__c = 'Teacher' LIMIT 1];
            if (teachers.isEmpty()) {
                return JSON.serialize(new Result(false, 'Teacher not found.'));
            }

            List<Community_User__c> students = [SELECT Id FROM Community_User__c WHERE Id = :studentId AND Role__c = 'Student' LIMIT 1];
            if (students.isEmpty()) {
                return JSON.serialize(new Result(false, 'Student not found.'));
            }

            Feedback__c feedback = new Feedback__c(
                Student__c = studentId,
                Teacher__c = teachers[0].Id,
                Emoji__c = emoji,
                Comment__c = comment != null ? comment.trim() : null
            );
            insert feedback;

            return JSON.serialize(new Result(true, 'Feedback submitted successfully.'));
        } catch (Exception e) {
            return JSON.serialize(new Result(false, 'Error submitting feedback: ' + e.getMessage()));
        }
    }

    // Fetch subjects for the current semester
    @AuraEnabled(cacheable=true)
    public static List<Subject__c> getCurrentSemesterSubjects() {
        try {
            String currentSemester = 'Spring 2025';
            return [SELECT Name, Semester__c, Teacher__r.First_Name__c, Teacher__r.Last_Name__c 
                    FROM Subject__c 
                    WHERE Semester__c = :currentSemester];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching subjects: ' + e.getMessage());
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
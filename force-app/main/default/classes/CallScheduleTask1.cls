public with sharing class CallScheduleTask1 {
    public static void callTask1(){
        ScheduleTask1 sc1 = new ScheduleTask1();
        String corn = '0 30 11 * * ?';
        String jobId = System.schedule('CreateJob',corn,sc1);
    }
}
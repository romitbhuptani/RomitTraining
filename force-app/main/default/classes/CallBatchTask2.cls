public with sharing class CallBatchTask2 {
    public static void callBatchTask2(){
    BatchTask2 bt2= new BatchTask2();
    String cronExpression = '0 0 9 * * ?'; 
    String jobId = System.schedule('CreateJob3', cronExpression, bt2);
    System.debug(jobId);
    }
}
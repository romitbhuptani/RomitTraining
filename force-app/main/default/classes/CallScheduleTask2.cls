public with sharing class CallScheduleTask2 {
    public static void callTask2(){
        ScheduleTask2 sc2 = new ScheduleTask2();
        integer random1 = (integer) (Math.random()*7) + 1;
        
        integer random2 = (integer) (Math.random()*7) + 1; 
        while(random1 == random2){
            random2 = (integer) (Math.random()*7) + 1;
        }
        String corn = '0 0 0 ? * '+random1+','+random2;
        String jobId = System.schedule('CreateJob2',corn,sc2);
    }
}
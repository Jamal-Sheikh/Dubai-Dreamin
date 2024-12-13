/*
 * 
 * @author Faraz
 * @since March 2024
*/
public with sharing class SpeakerHandler {
   
    public static void approvalAction(List<Speaker__c> speakerList){
       
       for(Speaker__c speaker:speakerList){
       if(speaker.Approval_Status__c =='Approved'){

            System.debug('in Approved');
        }
       else if (speaker.Approval_Status__c =='Rejected'){

           System.debug('in Rejected');
       }
        

       }
        

    }
}
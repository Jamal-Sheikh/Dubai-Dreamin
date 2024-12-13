/**
 * 
 * @author Faraz
 * @since March 2024
 */
public class ApprovalProcessController { 
    @AuraEnabled(cacheable=true)
    public static List<DenormalizedSession> getSessionTime(String recordId){

        ApprovalProcessSelector approvalProcessInstance = new ApprovalProcessSelector();    
       
        List<ProcessInstanceWorkitem>  selectedProcessInstanceWorkItem =  approvalProcessInstance.getProcessInstanceWorkItemById(recordId);     
        List<ProcessInstance> selectedProcessInstance =  approvalProcessInstance.getProcessInstanceById(selectedProcessInstanceWorkItem[0].ProcessInstanceId);
             
          
    SessionSelector sessionSelectorInstance = new SessionSelector();
    List<Session__c> selectedSessions =  sessionSelectorInstance.getSessionById(selectedProcessInstance[0].TargetObjectId);

       SessionSpeakerSelector sessionSpeakerSelectorInstance = new SessionSpeakerSelector();
       List<Speaker__c> selectedSessionSpeaker =  sessionSpeakerSelectorInstance.getSpeakersBySessionId(selectedSessions[0].Id);

    List<DenormalizedSession> sessionItemsList = new List<DenormalizedSession>();

     

    
    DenormalizedSession denormalizedSession = new DenormalizedSession();
       denormalizedSession.setSessionName(selectedSessions[0].Name); 
       denormalizedSession.setSessionDescription(selectedSessions[0].Session_Description__c); 
       denormalizedSession.setSessionTrack(selectedSessions[0].Session_Track__c); 
       denormalizedSession.setSessionTitle(selectedSessions[0].Session_Title__c); 
       denormalizedSession.setStartTime(String.valueof(selectedSessions[0].Session_Start_Time__c));
       denormalizedSession.setEndTime(String.valueof(selectedSessions[0].Session_End_Time__c));
       denormalizedSession.setSessionSelectionDetails(selectedSessions[0].Why_Session_is_Chosen__c);
       denormalizedSession.setSessionExpertiseOnSubject(selectedSessions[0].Session_Expertise_Details__c);
       denormalizedSession.setSessionIntroLink(selectedSessions[0].Intro_Video_Link__c);
       denormalizedSession.setSessionLevel(selectedSessions[0].Level__c);
       denormalizedSession.setSessionPresentedLink(selectedSessions[0].Already_Presented_Link__c);
       denormalizedSession.setSessionAlreadyPresented(selectedSessions[0].Does_session_already_presented__c);
       denormalizedSession.setIPRCompliance(selectedSessions[0].Intellectual_Property_Rights_Compliance__c);
       denormalizedSession.setIndividualPresentor(selectedSessions[0].Individual_Presenter_Confirmation__c);
     
     
     
       for(Speaker__c selectedSpeaker:selectedSessionSpeaker){
        if(selectedSpeaker.Speaker_Type__c=='Primary Speaker'){
          denormalizedSession.setSpeakerName(selectedSpeaker.Speaker_Name__c); 
          denormalizedSession.setSpeakerSocialMedia(selectedSpeaker.Speaker_Social_Media__c); 
          denormalizedSession.setSpeakerPhone(selectedSpeaker.Phone_Number__c); 
          denormalizedSession.setSpeakerTarget(selectedSpeaker.Speaker_Target__c);
          denormalizedSession.setSpeakerRole(selectedSpeaker.Speaker_Role__c); 
          denormalizedSession.setSpeakerEmail(selectedSpeaker.Email__c); 
          denormalizedSession.setSpeakerCompanyName(selectedSpeaker.Company_Name__c); 
          denormalizedSession.setSpeakerInformation(selectedSpeaker.Speaker_Information__c); 
          denormalizedSession.setSpeakerAge(selectedSpeaker.Speaker_Age__c); 
          denormalizedSession.setSpeakerGender(selectedSpeaker.Speaker_Gender__c); 
   

        }
        if(selectedSpeaker.Speaker_Type__c=='Co-Speaker'){
          denormalizedSession.setCoSpeakerName(selectedSpeaker.Speaker_Name__c); 
          denormalizedSession.setCoSpeakerPhone(selectedSpeaker.Phone_Number__c); 
          denormalizedSession.setCoSpeakerRole(selectedSpeaker.Speaker_Role__c); 
          denormalizedSession.setCoSpeakerEmail(selectedSpeaker.Email__c); 
          denormalizedSession.setCoSpeakerCompanyName(selectedSpeaker.Company_Name__c); 
   

        }


       }
     
     
     
       sessionItemsList.add(denormalizedSession);
     
       return sessionItemsList;
    }


    @AuraEnabled
    public static void setSessionTime(String sessionName, String sessionStartTime, String sessionEndTime){
   
        Time startTime = Time.newInstance(Integer.valueOf(sessionStartTime.split(':')[0]), Integer.valueOf(sessionStartTime.split(':')[1]), 0 ,0);
        Time endTime  = Time.newInstance(Integer.valueOf(sessionEndTime.split(':')[0]), Integer.valueOf(sessionEndTime.split(':')[1]), 0 ,0);
 

        Date myDate = Date.newInstance(2024, 12, 9);
        Datetime startDateTime = Datetime.newInstance(myDate.year(), myDate.month(), myDate.day(), startTime.hour(), startTime.minute(), startTime.second());
        Datetime endDateTime = Datetime.newInstance(myDate.year(), myDate.month(), myDate.day(), endTime.hour(), endTime.minute(), endTime.second());
  

        Long timeAvailable = endDateTime.getTime() - startDateTime.getTime();
        timeAvailable /= 60000;
       
        if(timeAvailable<30 && timeAvailable>60){
          throw new CustomException('Time Difference must be 30-60 minutes');
        }

      SessionSelector selectedSessionByName = new SessionSelector();

      List<Session__c> sessionList = selectedSessionByName.getSessionByName(sessionName);
      sessionList[0].Session_Start_Time__c= Time.newInstance(Integer.valueOf(sessionStartTime.split(':')[0]), Integer.valueOf(sessionStartTime.split(':')[1]), 0 ,0);
      sessionList[0].Session_End_Time__c= Time.newInstance(Integer.valueOf(sessionEndTime.split(':')[0]), Integer.valueOf(sessionEndTime.split(':')[1]), 0 ,0);
  
    Database.update(sessionList, true);
     


    }

public class CustomException extends Exception {}

}
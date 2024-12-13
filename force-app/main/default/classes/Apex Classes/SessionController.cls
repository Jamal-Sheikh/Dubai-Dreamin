/**
* @author: Muhammad Raza
* @description:  Controller Class for handling session information.
* @since: 01/01/24
* @Last Modified by: Muhammad Raza
*/
public with sharing class SessionController {
    
/**
* 
* @description:  This method utilizes the SessionSelector and SessionSpeakerSelector 
*                classes to fetch session and speaker information for the specified event.
* @param eventId - The ID of the event for which to retrieve session information.
* @return List<DenormalizedSession> - A list of denormalized session information for the specified event.
*/
    @AuraEnabled(cacheable=true)
    public static List<DenormalizedSession> getSessions(String eventId){
        List<Session__c> sessionList = new SessionSelector().getSessionsByEventId(eventId);
        List<DenormalizedSession> denormalizedSessionList = new List<DenormalizedSession>();
        
        for (Session__c session : sessionList) {
            DenormalizedSession denormalizedSession = new DenormalizedSession();
            denormalizedSession.sessionTitle = session.Session_Title__c;
            denormalizedSession.sessionDescription = session.Session_Description__c;
            denormalizedSession.sessionStartDate = session.Session_Start_Date__c;
            denormalizedSession.sessionEndDate = session.Session_End_Date__c;
            denormalizedSession.sessionDuration = session.Session_Duration__c;
            if (session.Session_Start_Time__c != null) {
                DateTime sessionStartTime = DateTime.newInstance(session.Session_Start_Date__c, session.Session_Start_Time__c);
                denormalizedSession.sessionStartTime = sessionStartTime.format('hh:mm a');
            } else {
                denormalizedSession.sessionStartTime = 'N/A';
            }

            if (session.Session_End_Time__c != null) {
                DateTime sessionEndTime = DateTime.newInstance(session.Session_End_Date__c, session.Session_End_Time__c);
                denormalizedSession.sessionEndTime = sessionEndTime.format('hh:mm a');
            } else {
                denormalizedSession.sessionEndTime = 'N/A';
            }
            List<Speaker__c> lstOfSpeakers = new SessionSpeakerSelector().getSpeakersBySessionId(session.Id);
            List<DenormalizedSpeaker> denormalizedSpeakers = new List<DenormalizedSpeaker>();
            for (Speaker__c speaker : lstOfSpeakers) {
                DenormalizedSpeaker denormalizedSpeaker = new DenormalizedSpeaker();
                denormalizedSpeaker.speakerName = speaker.Speaker_Name__c;
                denormalizedSpeaker.speakerImage = speaker.Speaker_Profile_Image__c;
                denormalizedSpeakers.add(denormalizedSpeaker);
            }
            denormalizedSession.lstOfSpeakers = denormalizedSpeakers;
            
            denormalizedSessionList.add(denormalizedSession);
        }
        
        return denormalizedSessionList;
    }
    @AuraEnabled(cacheable=true)
    public static List<DenormalizedSession> getAllSessions() {
        // Fetching all sessions
        List<Session__c> lstOfSession = SessionSelector.searchAllSessions();
    
        //  all session Ids
        Set<Id> sessionIds = new Set<Id>();
        for (Session__c session : lstOfSession) {
            sessionIds.add(session.Id);
        }
    
       
        List<Session_Speaker__c> lstOfSessionSpeakers = [
            SELECT Session__r.Id, 
                   Speaker__r.Id, 
                   Speaker__r.Speaker_Profile_Image__c, 
                   Session__r.Session_Title__c, 
                   Speaker__r.Speaker_Name__c 
            FROM Session_Speaker__c  
            WHERE Session__r.Id IN :sessionIds 
              AND Speaker__r.approval_Status__c='Approved'
        ];
    
        
        Map<Id, List<Session_Speaker__c>> sessionSpeakersMap = new Map<Id, List<Session_Speaker__c>>();
        for (Session_Speaker__c sessionSpeaker : lstOfSessionSpeakers) {
            if (!sessionSpeakersMap.containsKey(sessionSpeaker.Session__r.Id)) {
                sessionSpeakersMap.put(sessionSpeaker.Session__r.Id, new List<Session_Speaker__c>());
            }
            sessionSpeakersMap.get(sessionSpeaker.Session__r.Id).add(sessionSpeaker);
        }
    
        
        List<DenormalizedSession> denormalizedSessionList = new List<DenormalizedSession>();
        for (Session__c session : lstOfSession) {
            if (sessionSpeakersMap.containsKey(session.Id)) {
                for (Session_Speaker__c sessionSpeaker : sessionSpeakersMap.get(session.Id)) {
                    DenormalizedSession denormalizedSession = new DenormalizedSession();
                    denormalizedSession.speakerImage = sessionSpeaker.Speaker__r.Speaker_Profile_Image__c;
                    denormalizedSession.sessionTitle = sessionSpeaker.Session__r.Session_Title__c;
                    denormalizedSession.speakerName = sessionSpeaker.Speaker__r.Speaker_Name__c;
                    System.debug('Denormalized Session::' + denormalizedSession);
                    denormalizedSessionList.add(denormalizedSession);
                }
            }
        }
        
        System.debug('denormalizedSessionList @@' + denormalizedSessionList);
        return denormalizedSessionList;
    }
    
   
    @AuraEnabled(cacheable=true)
   
    public static List<DenormalizedSession> getSessionsBySearch(String searchKey ){
        List<Session__c> lstOfSession= SessionSpeakerSelector.searchSessionsByTypedKeyword(searchKey);
  
        List<DenormalizedSession> denormalizedSessionList = new List<DenormalizedSession>();
        for (Session__c session : lstOfSession) {
            List<Session_Speaker__c> lstOfSessionSpeakers = [SELECT Session__r.Id, Speaker__r.Id, Speaker__r.Speaker_Profile_Image__c, Session__r.Session_Title__c, Speaker__r.Speaker_Name__c 
                                                             FROM Session_Speaker__c  
                                                             WHERE Session__r.Id = :session.Id AND Speaker__r.approval_Status__c='Approved'];
            
            for (Session_Speaker__c sessionSpeaker : lstOfSessionSpeakers) {
                DenormalizedSession denormalizedSession = new DenormalizedSession();
                denormalizedSession.speakerImage = sessionSpeaker.Speaker__r.Speaker_Profile_Image__c;
                denormalizedSession.sessionTitle = sessionSpeaker.Session__r.Session_Title__c;
                denormalizedSession.speakerName = sessionSpeaker.Speaker__r.Speaker_Name__c;
                denormalizedSessionList.add(denormalizedSession);
            }
        }
        System.debug('denormalizedSessionList @@'+denormalizedSessionList.size());
        System.debug('denormalizedSessionList @@'+denormalizedSessionList);
        return denormalizedSessionList;
      }
    

  


      @AuraEnabled(cacheable=true)
      public static List<DenormalizedSession> fetchOnlyFilteredSessions(List<String> levels, List<String> keywords, List<String> trackedProducts, List<String> speakerRole ){
        List<Session__c> lstOfSession= SessionSelector.filteredSessions(levels,keywords,trackedProducts,speakerRole);
        List<DenormalizedSession> denormalizedSessionList = new List<DenormalizedSession>();
        for (Session__c session : lstOfSession) {
            List<Session_Speaker__c> lstOfSessionSpeakers = [SELECT Session__r.Id, Speaker__r.Id, Speaker__r.Speaker_Profile_Image__c, Session__r.Session_Title__c, Speaker__r.Speaker_Name__c 
                                                             FROM Session_Speaker__c  
                                                             WHERE Session__r.Id = :session.Id AND Speaker__r.approval_Status__c='Approved'];
            
            for (Session_Speaker__c sessionSpeaker : lstOfSessionSpeakers) {
                DenormalizedSession denormalizedSession = new DenormalizedSession();
                denormalizedSession.speakerImage = sessionSpeaker.Speaker__r.Speaker_Profile_Image__c;
                denormalizedSession.sessionTitle = sessionSpeaker.Session__r.Session_Title__c;
                denormalizedSession.speakerName = sessionSpeaker.Speaker__r.Speaker_Name__c;
                denormalizedSessionList.add(denormalizedSession);
            }
        }
        System.debug('Denormalized'+denormalizedSessionList);
        System.debug('Denormalized List Size'+denormalizedSessionList.size());
        return denormalizedSessionList;
      }
      
    
}
/**
* @author: Muhammad Raza
* @description:  Apex class for selecting event speakers.
* @created: 31/01/24
* @Last Modified by: Muhammad Raza
*/
public without sharing class EventSpeakerSelector {
    
 /**
* 
* @param whereClause - An optional WHERE clause to filter event speakers.
* @return List<Event_Speaker__c> -  A list of event speakers that meet the specified criteria.
*  @description:   This method constructs a dynamic SOQL query to fetch event speakers with specified fields.
*                  WHERE clause is optional and can be used for additional filtering.
*/
    public static List<Event_Speaker__c> getListEventSpeakers(String whereClause){
        String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
        String queryOnEventSpeaker = 'SELECT Speaker__r.Id, Speaker__r.Speaker_Name__c, Speaker__r.Speaker_Title__c, Speaker__r.Email__c, Speaker__r.Phone_Number__c, Speaker__r.Speaker_Information__c, Speaker__r.Speaker_Social_Media__c,Speaker__r.Speaker_Age__c,Speaker__r.Speaker_Gender__c ,Speaker__r.Speaker_Profile_Image__c ' +
            'FROM Event_Speaker__c '
            + clause  ;
        List<Event_Speaker__c> eventSpeakers = Database.query(queryOnEventSpeaker);
        return   eventSpeakers;
    }
    
/**
* 
* @param eventId - The ID of the event to filter event speakers.
* @return List<Speaker__c> - A list of speakers associated with the specified event.
* @description: Retrieves a list of speakers associated with a specific event ID.
*/
    
    public static List<Speaker__c> getSpeakerByEventId(String eventId){
        String clause = 'Event__c  = \''+eventId+'\' ';
        List<Event_Speaker__c> eventSpeakers = getListEventSpeakers(clause);
        
        List<Speaker__c> lstOfSpeakers = new List<Speaker__c>();
        
        for (Event_Speaker__c eventSpeaker : eventSpeakers) {
            Speaker__c speaker = eventSpeaker.Speaker__r;
            if (speaker != null) {
                lstOfSpeakers.add(speaker);
            }
        }
        return lstOfSpeakers; 
    } 
    
    
    
    
    
    /**
     * 
     * @param eventId 
     * @return  `List<Speaker__c>`
     */
    public static List<Speaker__c> getApprovedSpeakersByEventId(String eventId){
        String clause = 'Event__c  = \''+eventId+'\' AND  Speaker__r.Approval_Status__c= \'Approved\'';
        List<Event_Speaker__c> eventSpeakers = getListEventSpeakers(clause);
        
        List<Speaker__c> lstOfSpeakers = new List<Speaker__c>();
        
        for (Event_Speaker__c eventSpeaker : eventSpeakers) {
            Speaker__c speaker = eventSpeaker.Speaker__r;
            if (speaker != null) {
                lstOfSpeakers.add(speaker);
            }
        }
        return lstOfSpeakers; 
    } 
    
}
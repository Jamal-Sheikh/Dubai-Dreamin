/**
* 
* @author: Aneela Oad
* @description: Controls the logic and behavior of Event within the site.
* @created: 31/01/24
* @Last Modified by: 31/01/24
*/

public without sharing class EventController {
    
    
    /**
* @author: Aneela Oad
* @description: 
* @param String eventId
* @return: `DenormalizedEvent`
*/
    @AuraEnabled(cacheable=true)
    public static DenormalizedEvent getEvent(String eventId){
       
        Event__c event = new EventSelector().getEventById(eventId);
        
        DenormalizedEvent denormalizedEvent = new DenormalizedEvent();
        
        denormalizedEvent.eventTitle= event.Event_Title__c;
        denormalizedEvent.aboutUsDescription = event.Event_Organizer_Company__r.About_Us_Description__c;
        denormalizedEvent.eventDescription = event.Event_Description__c;
        denormalizedEvent.bannerImage = event.Banner_Image__c;
        denormalizedEvent.eventCity = event.Event_Address__City__s;
        denormalizedEvent.eventCountry = event.Event_Address__CountryCode__s;
        denormalizedEvent.eventStreet = event.Event_Address__Street__s;
        denormalizedEvent.eventStartDateTime=event.Event_Start_Date_and_Time__c;
        denormalizedEvent.eventEndDateTime=event.Event_End_Date_and_Time__c; 
        
        
        
        return denormalizedEvent;
        
    }
    
    // Fetch Dubai DreamIn Event Id
    @AuraEnabled(cacheable=true)
    public static String getDubaiDreaminEventId(){
        
        DenormalizedEvent denormalizedEvent = new DenormalizedEvent();
        String dubaieventId = EventSelector.getDubaiDreaminEvent();
        denormalizedEvent.dubaiDreamineventId=dubaieventId;
        return dubaieventId;
    }
    
}
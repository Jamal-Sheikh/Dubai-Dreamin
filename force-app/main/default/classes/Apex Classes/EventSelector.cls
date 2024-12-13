/**
* @author: Aneela Oad
* @description: Stores the query of entity Event__c
* @since: 01/01/24
* @Last Modified by: Aneela Oad
*/


public without sharing class EventSelector {

/**
* @author: Aneela Oad
* @description: Returns the list of events
* @param  String whereClause
* @return: `List<Event__c>`
*/
@AuraEnabled(cacheable=true)
public static List<Event__c> getEvents(String whereClause) {
    String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
           String query = 'SELECT Name, Id, Event_Description__c, Event_Title__c, Event_Organizer_Company__c, '
                      + 'Event_Organizer_Company__r.Name, Event_Organizer_Company__r.Logo__c, Event_Organizer__c, '
                      + 'Event_End_Date_and_Time__c, Event_Start_Date_and_Time__c, Event_Total_Duration__c, Event_Type__c, '
                      + 'Event_Charges__c, Event_Address__c, Banner_Image__c, Event_Address__City__s, '
                      + 'Event_Address__PostalCode__s, Event_Address__StateCode__s, Event_Address__CountryCode__s, Event_Address__Street__s, '
                      + 'Event_Organizer_Company__r.About_Us_Description__c '
                      + 'FROM Event__c '
                      + clause;
        // system.debug(query);
        List<Event__c> result = Database.query(String.valueOf(query));
        return result;
    }

public Event__c getEventById(String eventId){
        String clause = 'Id = \''+eventId+'\' ';
       List<Event__c> events = getEvents(clause);

        if (events.size() > 0) {
            return events.get(0);
        }
        return null;
    }
    // Fetch Dubai DreamIn Event
    public static String getDubaiDreaminEvent(){
        String eventId;
        List<Event__c> event=[SELECT Id,Name, Event_Start_Date_and_Time__c, Event_End_Date_and_Time__c FROM Event__c WHERE Name LIKE 'Dubai Dreamin%' Limit 1 ];
            for(Event__c ev:event){
               eventId=ev.Id;
            }
        System.debug('Dubai DreamIn Event Id'+eventId);
        return eventId;
    }
    
    
 }
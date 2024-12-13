/**
 *@author: Fatima
* @description: For retrieving attendee records
* @since: 07/05/24
 */

 public without sharing class AttendeeSelector {
   

    public static Map<String, Id> getAttendeesbyNameandEmail(Set<String> speakerNames, Set<String> speakerEmails) {
        Map<String, Id> attendeeMap = new Map<String, Id>();
        
        String whereClause = ' Attendee_Full_Name__c IN :speakerNames AND Email__c IN :speakerEmails' ;
        for (Attendee__c attendee : getAttendees(whereClause,speakerNames,speakerEmails)) {
            attendeeMap.put(attendee.Attendee_Full_Name__c + '|' + attendee.Email__c, attendee.Id);
        }
    
        return attendeeMap;
    }
    
    /**
     * @description Executes a query to retrieve attendees based on the provided WHERE clause
     * @param whereClause 
     * @return  `List<Attendee__c>`
     */
    private static List<Attendee__c> getAttendees(String whereClause,Set<String> speakerNames, Set<String> speakerEmails) {
        String clause = whereClause != null ? ' WHERE ' + whereClause : '';
        String query = 'SELECT Id, Attendee_Full_Name__c, Email__c FROM Attendee__c ' + clause;
        return Database.query(query);
    }

     
    
   
}
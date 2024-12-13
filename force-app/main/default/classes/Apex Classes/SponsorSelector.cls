/**
* @author: Muhammad Raza
* @description: A class for retrieving sponsor information based on certain criteria.
* @since: 31/01/24
* @Last Modified by: Muhammad Raza
*/
public without sharing class SponsorSelector {
    
/**
* 
* @param whereClause The optional WHERE clause to filter sponsor records.
* @return List<Sponsor__c> A list of sponsor records that meet the specified criteria.
* @description - This method constructs a dynamic SOQL query to fetch sponsor records with specified fields,
*                 applying an optional WHERE clause to filter the records.
*/
    
    public  List<Sponsor__c> getSponsorList(String whereClause) {
        String clause = String.isEmpty(whereClause) ? '' : ' WHERE ' + whereClause;
        String queryOnSponsors = 'SELECT Id,Sponsor__r.Logo__c,Sponsorship_Level__c,Event__r.Id FROM Sponsor__c' + clause;
        List<Sponsor__c> eventSponsors = Database.query(queryOnSponsors);
        
        return eventSponsors;
    }
    
/**
* 
* @param eventId The ID of the event to filter sponsor records.
* @return List<Sponsor__c> A list of sponsor records associated with the specified event.
* @description -   Retrieves a list of sponsors associated with a specific event ID.
*/
    
    public  List<Sponsor__c> getSponsorsByEventId(String eventId) {
        String clause = 'Event__r.Id = \'' + eventId + '\' ';
        List<Sponsor__c> eventSponsors = getSponsorList(clause);
        
        return eventSponsors;
    }
}
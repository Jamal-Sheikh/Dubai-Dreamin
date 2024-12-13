/**
 *@author: Fatima
* @description: For retrieving Speaker records
* @since: 07/05/24
 */

public without sharing class SpeakerSelector {
    

/**
 * @description retrieving speaker record
 * @param whereClause 
 * @return  `List<Speaker__c>`
 */
    public static List<Speaker__c> getSpeaker(String whereClause) {
        String clause = whereClause != null ? ' WHERE ' + whereClause : '';
        String query = 'SELECT Id,Attendee__c, Ticket_Amount__c,Amount_To_Be_Refund__c FROM Speaker__c ' + clause;
        return Database.query(query);
    }

    /**
     * @description Retrieving speaker by Id
     * @param Id 
     * @return  `Speaker__c`
     */
    public Speaker__c getSpeakerById(String Id) {

        String clause =  ' Id = \'' + Id + '\'';
        List<Speaker__c> speaker = getSpeaker(clause);
        if (speaker.size() > 0) {
             return speaker.get(0);
        }
        return null;
    
      
    }
    public static List<Speaker__c> getlstofSpeakerID(String whereClause) {
        String comingWhereClause = ' Id = \'' + whereClause + '\'';
        String clause = comingWhereClause != null ? ' WHERE' + comingWhereClause : '';
        System.debug('@@ clause::'+clause);
        String query = 'SELECT Id,Speaker_name__c,Approval_Status__c,Voucher_code__c FROM Speaker__c ';
        query = query +clause;
        system.debug('Check Query' +query);
        return Database.query(query);
    }
}
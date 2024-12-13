/**
* @author: Aneela Oad
* @description: handles the selection of Navigation Control records;
* @since: 01/12/24
* @Last Modified by: Aneela Oad
*/
public without sharing class NavigationControlSelector{
    /**
    * @author: Aneela Oad
    * @description: Returns the list of header navigation item based on record type and evend id
    * @param  String recordType, String eventId
    * @return: `List<Navigation_Control__c> `
    */
     public static List<Navigation_Control__c> getHeaderNavigationMenu( String recordType, String eventId){
  
        String query = 'SELECT Menu_Item_Name__c,	Link_URL__c, Event__r.Event_Organizer_Company__r.Logo__c, '
        +'RecordType.DeveloperName, Order__c, is_Visible__c, Social_Media_Type__c, Section__c '
        + 'FROM Navigation_Control__c  '
        + 'WHERE Is_Visible__c = true '
        + 'AND RecordType.DeveloperName = \''+recordType+'\''
        + 'AND Event__c = \''+eventId+'\''
        + 'ORDER BY Order__c NULLS LAST ';

        List<Navigation_Control__c> result = Database.query(String.valueof(query));
        return result;
    }
}
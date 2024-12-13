/**
* @author: Aneela Oad
* @description: Manages the selection of frequently asked questions (FAQs) in the application.
* @since: 10/01/24
* @Last Modified by: Aneela Oad
*/
public class FAQsSelector { 

    /**
    * @author: Aneela Oad
    * @description: Fetches the list of FAQs based on whereClause
    * @param  String whereClause
    * @return: `List<FAQ__c>`
    */
    public static List<FAQ__c> getFAQs(String whereClause){
        String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
        String query = 'SELECT Question__c, Answer__c FROM FAQ__c ' +clause;
        List<FAQ__c> result = Database.query(String.valueof(query));
  
        return result;
    }

    /**
    * @author: Aneela Oad
    * @description: Returns the list of FAQs based on event Id
    * @param  String eventId
    * @return: `List<FAQ__c> `
    */
    public static List<FAQ__c> getFAQsByEventId(String eventId){
        String clause = 'Event__c = \''+eventId+'\' ';
        List<FAQ__c> faqs = getFAQs(clause);
       
       return faqs;
    

    }
}
/**
* @author: Aneela Oad
* @description: Handles the selection of question records 
* @since: 11/01/24
* @Last Modified by: Aneela Oad
*/
public with sharing class QuestionSelector {

    /**
    * @author: Aneela Oad
    * @description: returns the list of question records based on eventId
    * @param  String eventId)
    * @return: `List<Question__C>`
    */
@AuraEnabled(cacheable=true)
public static List<Question__C> getQuestionsList(String eventId){
        String query = 'SELECT Id, Name, Question__c, Question_Type__c, '
        +'(SELECT Id, Option__c FROM Question_Options__r) '      
        +'FROM Question__c WHERE Event__c = \''+eventId + '\'';
        List<Question__C> result = Database.query(String.valueof(query));

        return result;
    }
}
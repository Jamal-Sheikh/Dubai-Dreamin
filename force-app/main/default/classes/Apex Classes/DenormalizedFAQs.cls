/**
* @author: Aneela Oad
* @description: Handles the denormalization process for FAQs data.
* @since: 4/12/23   
* @Last Modified by: Aneela Oad
*/
public class DenormalizedFAQs {

    @AuraEnabled public String question;
    @AuraEnabled public String answer;

    public DenormalizedFAQs(){

    }

}
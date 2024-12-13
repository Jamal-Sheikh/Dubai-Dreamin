/**
* @author: Aneela Oad
* @description: Controls the logic and behavior of FAQs within the application.
* @since: 04/01/24
* @Last Modified by: Aneela Oad
*/
public without sharing class FAQsController {

    /**
    * @author: Aneela Oad
    * @description: Returns the list of FAQs
    * @param  String eventId
    * @return: `List<DenormalizedFAQs>`
    */
     @AuraEnabled(cacheable=true)
    public static List<DenormalizedFAQs> getFAQsList(String eventId){

        List<DenormalizedFAQs> denormalizedFaqsList = new List<DenormalizedFAQs>();
        List<FAQ__c> faqsList = FAQsSelector.getFAQsByEventId(eventId);
        for (FAQ__c faq : faqsList) {
        DenormalizedFAQs denormalizedFaq = new DenormalizedFAQs();
        denormalizedFaq.question=faq.Question__c;
        denormalizedFaq.answer=faq.Answer__c;
        
        denormalizedFaqsList.add(denormalizedFaq);
        }

        return denormalizedFaqsList ;
    }
}
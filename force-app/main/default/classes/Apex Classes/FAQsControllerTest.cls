/**
* @author: Aneela Oad
* @description: Test class for FAQsController
* @since: 01/02/24  
* @Last Modified by: Aneela Oad
*/
@isTest
public class FAQsControllerTest {

    /**
    * @author: Aneela Oad
    * @description: Tests the getFAQsList()
    * @param  none
    * @return: void
    */
    @isTest
    static void getFAQsListTest() {
      
        Event__c testEvent = new Event__c(Name = 'Test Event', Event_Title__c = 'Test Event Title');
        insert testEvent;

        FAQ__c faq1 = new FAQ__c(Event__c = testEvent.Id, Question__c = 'Test Question 1', Answer__c = 'Test Answer 1');
        FAQ__c faq2 = new FAQ__c(Event__c = testEvent.Id, Question__c = 'Test Question 2', Answer__c = 'Test Answer 2');
        insert new List<FAQ__c>{faq1, faq2};

        List<DenormalizedFAQs> result = FAQsController.getFAQsList(testEvent.Id);

    
        Assert.areEqual(2, result.size(), 'Expected List size');
        Assert.areEqual('Test Question 1', result[0].question, 'Expected Question 1');
        Assert.areEqual('Test Answer 1', result[0].answer, 'Expected Answer 1');
        Assert.areEqual('Test Question 2', result[1].question, 'Expected Question 2');
        Assert.areEqual('Test Answer 2', result[1].answer, 'Expected Answer 1');
    }
}
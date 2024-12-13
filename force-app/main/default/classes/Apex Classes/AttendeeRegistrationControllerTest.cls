/**
* @author: Aneela Oad
* @description: Test Class for AttendeeRegistrationController.
* @since: 02/02/24
* @Last Modified by: Aneela Oad
*/
@isTest
public class AttendeeRegistrationControllerTest {
    /**
    * @author: Aneela Oad
    * @description: Test the getEventQuestions()
    * @param  none
    * @return: void
    */
    @isTest
    static void getEventQuestionsTest(){
      
        Event__c testEvent = new Event__c(Name = 'Test Event', Event_Title__c='Test Event Title');
        insert testEvent;

        Question__c question1 = new Question__c(Event__c = testEvent.Id, Question__c = 'Test Question 1', Question_Type__c = 'Text');
        Question__c question2 = new Question__c(Event__c = testEvent.Id, Question__c = 'Test Question 2', Question_Type__c = 'Single-Select');
        insert new List<Question__c>{question1, question2};

        Question_Option__c option1 = new Question_Option__c(Question__c = question2.Id, Option__c = 'Option 1');
        Question_Option__c option2 = new Question_Option__c(Question__c = question2.Id, Option__c = 'Option 2');
        insert new List<Question_Option__c>{option1, option2};

      
        List<DenormalizedQuestion> result = AttendeeRegistrationController.getEventQuestions(testEvent.Id);

       Assert.areEqual(2, result.size(), 'Expected QuestionsList size');
       Assert.areEqual('Test Question 1', result[0].questionName, 'Expected Question Name 1');
       Assert.areEqual(question1.Id, result[0].questionId, 'Expected Question Id 1');
       Assert.areEqual('Text', result[0].questionType, 'Expected Question Type');
       Assert.areEqual(0, result[0].questionOptionList.size(), 'Expected Question Option List');
       Assert.areEqual('Test Question 2', result[1].questionName, 'Expected Question Name 2');
       Assert.areEqual(question2.Id, result[1].questionId, 'Expected Question Id');
       Assert.areEqual('Single-Select', result[1].questionType, 'Expected Question Type');
       Assert.areEqual(2, result[1].questionOptionList.size(),'Expected Question Options Size');
  

    }
    @isTest
    static void registerAttendeeTest() {
     
        Event__c testEvent = new Event__c(Name = 'Test Event', Event_Title__c='Test Event Title');
        insert testEvent;

        String attendeeInfo = '{"eventId": "' + testEvent.Id + '", "firstName": "John", "lastName": "Doe", "email": "john.doe@example.com", "responsesList": []}';

      
        Test.startTest();
        AttendeeRegistrationController.registerAttendee(attendeeInfo);
        Test.stopTest();
 
        List<Attendee__c> attendees = [SELECT Id FROM Attendee__c WHERE Event__c = :testEvent.Id LIMIT 1];
        List<Question_Response__c> responses = [SELECT Id FROM Question_Response__c WHERE Attendee__c = :attendees[0].Id];

 
        Assert.areEqual(1, attendees.size(),'Expected Attendees List');
        Assert.areEqual(0, responses.size(),'Expected Responses List'); 
     
        String attendeeInfoWithResponses = '{"eventId": "' + testEvent.Id + '", "firstName": "Jane", "lastName": "Doe", "email": "jane.doe@example.com", "responsesList": [{"questionId": "SomeQuestionId", "response": "SomeResponse"}]}';


        Test.startTest();
        AttendeeRegistrationController.registerAttendee(attendeeInfoWithResponses);
        Test.stopTest();


        responses = [SELECT Id FROM Question_Response__c WHERE Attendee__c = :attendees[0].Id];

 
        Assert.areEqual(1, responses.size(), 'Expected responses list');
    }

}
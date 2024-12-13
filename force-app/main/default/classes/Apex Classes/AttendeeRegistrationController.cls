/**
* @author: Aneela Oad
* @description: Manages the logic and functionality related to attendee registration.
* @since: 20/12/23
* @Last Modified by: Aneela Oad
*/
public with sharing class AttendeeRegistrationController {

  /**
  * @author: Aneela Oad
  * @description: Manages of fetching question records by eventId
  * @param  String eventId
  * @return: `List<DenormalizedQuestion>`
  */
  @AuraEnabled(cacheable=true)
  public static List<DenormalizedQuestion> getEventQuestions(String eventId) {
      List<DenormalizedQuestion> denormalizedQuestionsList = new List<DenormalizedQuestion>();
      List<Question__c> questionsList = QuestionSelector.getQuestionsList(eventId);

      for (Question__c question : questionsList) {
          DenormalizedQuestion denormalizedQuestion = new DenormalizedQuestion();
          denormalizedQuestion.questionName = question.Question__c;
          denormalizedQuestion.questionId = question.Id;
          denormalizedQuestion.questionType = question.Question_Type__c;
          denormalizedQuestion.showTextOptions = denormalizedQuestion.questionType == 'Text';
          denormalizedQuestion.showSingleSelectOptions = denormalizedQuestion.questionType == 'Single-Select';
          denormalizedQuestion.showMultiSelectOptions = denormalizedQuestion.questionType == 'Multi-Select';

          List<Question_Option__c> options = question.Question_Options__r;
          List<DenormalizedOption> denormalizedOptions = new List<DenormalizedOption>();

            for (Question_Option__c questionOption : options) {
             DenormalizedOption denormalizedOption = new   DenormalizedOption();
             denormalizedOption.questionId = question.Id ;
             denormalizedOption.option = questionOption.Option__c;
               
               denormalizedOptions.add(denormalizedOption);
            }

          denormalizedQuestion.questionOptionList = denormalizedOptions;
          denormalizedQuestionsList.add(denormalizedQuestion);
      }

      return denormalizedQuestionsList;
  }

  /**
  * @author: Aneela Oad
  * @description: Handles registration of attendee along with his/her responses
  * @param  String attendList
  * @return: void
  */
   @AuraEnabled
  public static void registerAttendee(String attendeeInfo) {
      DenormalizedAttendee denormalizedAttendeeInfo = (DenormalizedAttendee) JSON.deserialize(attendeeInfo, DenormalizedAttendee.class);
      System.debug('attendeeInfo ---> '+ attendeeInfo);
      List<DenormalizedResponse> responsesList = denormalizedAttendeeInfo.responsesList;
      List<String> responsesWithQuestionIds = new List<String>();
    
      List<Contact> existingContacts = ContactSelector.getContacts(denormalizedAttendeeInfo.email);
    Contact existingContact;

    Id contactId;

    if (existingContacts.size() == 0 ) {
        Contact contact = new Contact();
        contact.FirstName = denormalizedAttendeeInfo.firstName;
        contact.LastName = denormalizedAttendeeInfo.lastName;
        contact.email = denormalizedAttendeeInfo.email;
        if(Schema.sObjectType.Contact.isCreateable()){
          insert contact;
        }
          contactId = contact.id;  
      
    } 
    else {
      existingContact =existingContacts.get(0);
      contactId = existingContact.Id;
    }
    Attendee__c attendee = new Attendee__c(
      Event__c = denormalizedAttendeeInfo.eventId,
      Attendee__c = contactId
    );
    if( Schema.sObjectType.Attendee__c.isCreateable()) {
      insert attendee;
    }
      
  
      
      List<Question_Response__c> responseListToInsert = new List<Question_Response__c>();

    for (DenormalizedResponse res : responsesList) {
        Question_Response__c response = new Question_Response__c();

        response.Question_Name__c = res.questionId;
        response.Response__c = res.response;
        response.Attendee__c = attendee.Id;

        responseListToInsert.add(response);
    }
    if( Schema.sObjectType.Question_Response__c.isCreateable()) {
      if (!responseListToInsert.isEmpty()) {
        insert responseListToInsert;
    } 
    }
      
       
}
    
  }
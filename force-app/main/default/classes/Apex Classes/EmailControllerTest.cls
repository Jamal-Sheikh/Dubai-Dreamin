@isTest
public with sharing class EmailControllerTest {
    @isTest
    public static void testSendSubmissionEmails(){
   
    Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Approved',
            Submission_Received__c = true
        );
        insert testSpeaker;

        Timeline__c testTimeline = new Timeline__c(
            Name= 'Speaker Submission Deadline',
            Date__c= Date.parse('12/12/2024')
        );
        insert testTimeline;
         // Create a ContentDocument and ContentDocumentLink linked to the testSpeaker
         Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body to be insert in test class for testing the'); 
            
         ContentVersion contentVersion_1 = new ContentVersion(
             Title='SampleTitle', 
             PathOnClient ='SampleTitle.jpg',
             VersionData = bodyBlob, 
             origin = 'H'
         );
         insert contentVersion_1;

        EmailController.FlowInputs flowInputs = new EmailController.FlowInputs();
        flowInputs.ids = new List<Id>{testSpeaker.Id};
        flowInputs.flowType = 'Opening';


  

  Test.startTest();
  // Call the method being tested
  EmailController.sendSubmissionEmails(new List<EmailController.FlowInputs>{flowInputs});
  Test.stopTest();



        EmailController.FlowInputs flowInputs2 = new EmailController.FlowInputs();
        flowInputs2.ids = new List<Id>{testSpeaker.Id};
        flowInputs2.flowType = 'Reminder';


  

//   Test.startTest();
  // Call the method being tested
  EmailController.sendSubmissionEmails(new List<EmailController.FlowInputs>{flowInputs2});
//   Test.stopTest();




        EmailController.FlowInputs flowInputs3 = new EmailController.FlowInputs();
        flowInputs3.ids = new List<Id>{testSpeaker.Id};
        flowInputs3.flowType = 'PostDeadline';


  

//   Test.startTest();
  // Call the method being tested
  EmailController.sendSubmissionEmails(new List<EmailController.FlowInputs>{flowInputs3});
//   Test.stopTest();

  // Verify that emails are sent
 // List<Messaging.SingleEmailMessage> sentEmails = [SELECT Id FROM Messaging.SingleEmailMessage];
 // System.assertEquals(1, sentEmails.size(), 'One email should be sent');

   } 
}
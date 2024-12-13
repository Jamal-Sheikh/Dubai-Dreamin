@isTest
public class ApprovalProcessControllerTest {
    

    @isTest
    static void testGetSessionTime() {
        // Test data setup
        String sessionStartTime = '12:00';
        String sessionEndTime =     '12:45';
        System.debug(sessionStartTime);
        System.debug(sessionEndTime);
        Time startTime = Time.newInstance(Integer.valueOf(sessionStartTime.split(':')[0]), Integer.valueOf(sessionStartTime.split(':')[1]), 0 ,0);
        Time endTime  = Time.newInstance(Integer.valueOf(sessionEndTime.split(':')[0]), Integer.valueOf(sessionEndTime.split(':')[1]), 0 ,0);
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
            Session_Description__c = 'Test Description',
            Session_Track__c = 'Data Cloud',
            Session_Title__c = 'Test Title',
            Session_Start_Time__c = startTime,
            Session_End_Time__c = endTime
        );
        insert testSession;

        Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Speaker_Type__c = 'Primary Speaker',
           Approval_Status__c = 'Pending'
        );
        insert testSpeaker;
        
         Speaker__c testCoSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Co Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'testco@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Speaker_Type__c = 'Co-Speaker',
           Approval_Status__c = 'Pending'
        );
        insert testCoSpeaker;

        Session_Speaker__c testSessionSpeaker = new Session_Speaker__c(
            Session__c = testSession.Id,
            Speaker__c = testSpeaker.Id
        );
        insert testSessionSpeaker;
        
        Session_Speaker__c testSessionCoSpeaker = new Session_Speaker__c(
            Session__c = testSession.Id,
            Speaker__c = testCoSpeaker.Id
        );
        insert testSessionCoSpeaker;





        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        Approval.ProcessSubmitRequest req1 = 
        new Approval.ProcessSubmitRequest();
    req1.setComments('Submitting request for approval.');
    req1.setObjectId(testSession.id);

    // Submit on behalf of a specific submitter
    req1.setSubmitterId(u.Id); 

    // Submit the record to specific process and skip the criteria evaluation
    req1.setProcessDefinitionNameOrId('Approve_Session');
    req1.setSkipEntryCriteria(true);

    // Submit the approval request for the account
    Approval.ProcessResult resultApprovl = Approval.process(req1);
       
       
       
    ProcessInstanceWorkitem testProcessInstanceWorkItem = [Select id, ProcessInstanceId ,OriginalActorId from ProcessInstanceWorkitem  limit 1];
       
       
       
       
       
       
       
       
        // ProcessInstance testProcessInstance = new ProcessInstance(
        //     // Populate required fields
        // );
        // insert testProcessInstance;

        // ProcessInstanceWorkitem testProcessInstanceWorkItem = new ProcessInstanceWorkitem(
        //     ProcessInstanceId = testProcessInstance.Id,
        //     // CurrentNodeId = 'Test Node',
        //     OriginalActorId = UserInfo.getUserId()
        //     // RemindersSent = 0
        //     // Populate other required fields
        // );
        // insert testProcessInstanceWorkItem;




































        // Call the method to test
        Test.startTest();
        List<DenormalizedSession> result = ApprovalProcessController.getSessionTime(testProcessInstanceWorkItem.Id);
        Test.stopTest();

        // Assert the result
        System.assertNotEquals(0, result.size(), 'Expected result list to contain at least one item');
        DenormalizedSession session = result[0];
        // System.assertEquals(testSession.Name, session.getSessionName(), 'Unexpected session name');
        // Add more assertions for other fields as needed
    }

    @isTest
    static void testSetSessionTime() {
        // Test data setup
        Session__c testSession = new Session__c(
            // Name = 'Test Session',
            Session_Description__c = 'Test Description',
            Session_Track__c = 'Data Cloud',
            Session_Title__c = 'Test Title',
            Session_Start_Time__c =Time.newInstance(12, 0, 0, 0),
            Session_End_Time__c = Time.newInstance(12, 45, 0, 0),
            Session_Start_Date__c = Date.newInstance(2024, 12, 9),
            Session_End_Date__c = Date.newInstance(2024, 12, 9)
        );
        insert testSession;
        Session__c testSessionInserted = [SELECT Name, Session_Start_Time__c, Session_End_Time__c FROM Session__c  limit 1];
        // Call the method to test
        system.debug(testSessionInserted.Name);
        Test.startTest();
        ApprovalProcessController.setSessionTime(testSessionInserted.Name, '09:00', '10:00');
        Test.stopTest();

        // Retrieve the session after the method execution
        Session__c updatedSession = [SELECT Session_Start_Time__c, Session_End_Time__c FROM Session__c WHERE Name = :testSessionInserted.Name];

        // Assert the result
        System.assertEquals(Time.newInstance(9, 0, 0, 0), updatedSession.Session_Start_Time__c, 'Unexpected start time');
        System.assertEquals(Time.newInstance(10, 0, 0, 0), updatedSession.Session_End_Time__c, 'Unexpected end time');
    }
    //
}
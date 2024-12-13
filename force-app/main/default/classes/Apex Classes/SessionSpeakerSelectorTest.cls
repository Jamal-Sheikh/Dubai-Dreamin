@isTest
public class SessionSpeakerSelectorTest {
    @isTest
    static void testGetSessionSpeakerBySpeakerId(){


        Speaker__c testSpeaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Speaker_Social_Media__c = 'Test Social Media',
            Phone_Number__c = '1234567890',
            Speaker_Target__c = 'Admins',
            Email__c = 'test@example.com',
            Company_Name__c = 'Test Company',
            Speaker_Information__c = 'Test Information',
            Approval_Status__c = 'Pending'
        );
        insert testSpeaker;

        SessionSpeakerSelector testobje = new SessionSpeakerSelector();
        testobje.getSessionSpeakerBySpeakerId(testSpeaker.Id);
    }
}
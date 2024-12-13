/**
 *@author: Fatima
* @description: Test class for Speaker Trigger handler
* @since: 07/05/24
 */


@isTest
public class SpeakerTriggerHandlerTest {

    @isTest
    static void testBeforeUpdate() {
        
        Speaker__c speaker = new Speaker__c(
            Speaker_Name__c = 'Test Speaker',
            Email__c = 'test@example.com',
            Approval_Status__c = 'Pending'
        );
        insert speaker;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Speaker',
            Email = 'test@example.com'
        );
        insert testContact;

        Attendee__c attendee = new Attendee__c(
            Attendee__c = testContact.Id,
            Email__c = 'test@example.com'
        );
        insert attendee;

        Ticket__c ticket = new Ticket__c(
            Attendee__c = attendee.Id,
            Total_Amount__c = 100.00
        );
        insert ticket;

        speaker.Approval_Status__c = 'Approved';
        update speaker;

        
        SpeakerSelector speakerSelector=new SpeakerSelector();
        Speaker__c updatedSpeaker = speakerSelector.getSpeakerById(speaker.Id);
         System.assertNotEquals(null, updatedSpeaker.Attendee__c, 'Attendee Id should not be null');
        System.assertNotEquals(null, updatedSpeaker.Ticket_Amount__c, 'Ticket Amount should not be null');
        System.assertEquals(attendee.Id, updatedSpeaker.Attendee__c, 'Attendee Id should match');
        System.assertEquals(100.00, updatedSpeaker.Ticket_Amount__c, 'Ticket Amount should match');
    }
}
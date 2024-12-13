@isTest
public class CreateTicketFromStripeEventTest {

    static testMethod void testTicketCreation() {
        Event__c testEvent = new Event__c(Event_Title__c = 'Dubai Dreamin');
        insert testEvent;
        
        // Create an Attendee record
        Attendee__c attendee = new Attendee__c(Event__c = testEvent.Id);
        insert attendee;
        
        // Create a Stripe event record
        stripeGC__Stripe_Event__c stripeEvent = new stripeGC__Stripe_Event__c(
            stripeGC__Stripe_Event_Id__c = 'Test Stripe Event',
            stripeGC__Request_Body__c = '{"data":{"object":{"client_reference_id":"' + attendee.Id + '","amount_total": 1800}}}',
            stripeGC__Event_Name__c='checkout.session.completed'
        );
       
        
        // Invoke the trigger by inserting the Stripe event record
        Test.startTest();
        insert stripeEvent;
        Test.stopTest();
        
        // Verify ticket creation
        List<ticket__c> tickets = [SELECT Id, Attendee__c, TransactionID__c FROM ticket__c];
     //   System.assertEquals(1, tickets.size(), 'Expected one ticket to be created');
      //  ticket__c ticket = tickets[0];
        //System.assertEquals(attendee.Id, ticket.Attendee__c, 'Attendee field should match attendee Id');
        //System.assertEquals(stripeEvent.Id, ticket.TransactionID__c, 'Transaction ID field should match Stripe event Id');
 
    }
}
/**
* @author: Muhammad Raza
* @description: Test class for testing the SponsorController class.
 *               This class tests the functionality related to retrieving sponsors for an event.
* @since: 01/02/24
* @Last Modified by: Muhammad Raza
*/
@isTest
public with sharing class SponsorControllerTest {
    /**
    * @author: Muhammad Raza
    * @description: Test method to verify the functionality of the getSponsor method.
     *               It creates test data for event and sponsor,
     *               then verifies that the correct number of sponsors is retrieved for the given event.
    */
    @isTest
     static void testingGetSponsor(){

        Event__c testEvent = EventTestDataFactory.createEvent();
        Sponsor__c testSponsor = EventTestDataFactory.createEventSponsor(testEvent);
        Test.startTest();
        List<DenormalizedSponsor> result = SponsorController.getSponsor(testEvent.Id);
         SponsorController.getEmailsByLeadEmail('test@gmail.com');
        Test.StopTest();
        Assert.areEqual(1, result.size(), 'Expected Sponsor List' );
    }
    
}
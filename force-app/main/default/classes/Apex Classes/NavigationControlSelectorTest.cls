/**
* @author: Aneela Oad
* @description: Test Class for NavigationControlSelector
* @since: 01/02/24
* @Last Modified by: Aneela Oad
*/
@isTest
public class NavigationControlSelectorTest {

    @isTest
    static void getHeaderNavigationMenuTest() {
             Id recordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Header Navigation').getRecordTypeId();

        Event__c testEvent = new Event__c();
        testEvent.Event_Title__c = 'Zameen Expo - The Annual Festival11';
        insert testEvent;

        Navigation_Control__c testRecord = new Navigation_Control__c(
            RecordTypeId = recordType,
            Event__c = testEvent.Id,
            Is_Visible__c = true
           
        );
        insert testRecord;

   
        List<Navigation_Control__c> result = NavigationControlSelector.getHeaderNavigationMenu(
           'Header_Navigation', testEvent.Id
        );

        Assert.areEqual(1, result.size(), 'Expected one record in the result');
    }
}
/**
* @author: Aneela Oad
* @description: Test Class for NavigationbarController
* @since: 01/02/24  
* @Last Modified by: Aneela Oad
*/
@isTest
public class NavigationbarControllerTest {
    
    /**
    * @author: Aneela Oad
    * @description: Test the getNavigationItems()
    * @param  none
    * @return: void
    */
    @isTest
    static void getNavigationItemsTest() {
        Account acc = new Account();
        acc.Name='test account';
        acc.Logo__c = 'https://play-lh.googleusercontent.com/8LfdOiQHWMsE1WXP_18yj61asw00uAHucGH2mOpDSesc_C5xEU9KJ_n1R0tLuhPZRW88=w240-h480-rw';
        insert acc;
        
        Event__c testEvent = new Event__c();
        testEvent.Name = 'Zameen Expo11';
        testEvent.Event_Title__c = 'Zameen Expo - The Annual Festival11';
        testEvent.Event_Organizer_Company__c = acc.Id;
        testEvent.Event_Type__c = 'Hybrid';
        
        insert testEvent;
       Schema.RecordTypeInfo headerRecordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Header Navigation');

        Navigation_Control__c testItem = new Navigation_Control__c(
            Event__c = testEvent.Id,
            Menu_Item_Name__c = 'About Us',
            Section__c = 'About Us',
            Is_Visible__c = true,
            RecordTypeId = headerRecordType.getRecordTypeId()
        );
        insert testItem;
       
        
        Test.startTest();
        List<DenormalizedNavigationControl> result = NavigationbarController.getNavigationItems(testEvent.Id);
       List<Navigation_Control__c> headerNavigationItemList = NavigationControlSelector.getHeaderNavigationMenu(headerRecordType.getDeveloperName(), testEvent.Id);
       //List<Navigation_Control__c> footerNavigationItemList = NavigationControlSelector.getHeaderNavigationMenu(recordType1, testEvent.Id);
        Test.stopTest();
        
       
       Assert.areEqual(1, headerNavigationItemList.size(), 'Expected one item');
        
    }
}
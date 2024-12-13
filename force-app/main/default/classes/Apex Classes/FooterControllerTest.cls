/**
* @author: Aneela Oad
* @description: Test Class for FooterController.
* @since: 02/02/24
* @Last Modified by: Aneela Oad
*/
@isTest
public class FooterControllerTest {
	@isTest
    static void getFooterItemsTest() {
     
        Event__c testEvent = new Event__c();
        testEvent.Name = 'Test Event';
        testEvent.Event_Title__c = 'Test Event Title';
   		insert testEvent;
    

        Schema.RecordTypeInfo footerRecordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Footer Navigation');

        Navigation_Control__c navControl = new Navigation_Control__c(
            RecordTypeId = footerRecordType.getRecordTypeId(),
            Social_Media_Type__c = 'Facebook',
            Is_Visible__c = true,
            Event__c = testEvent.Id
          
        );
        insert navControl;

    
        Test.startTest();
        List<DenormalizedFooter> result = FooterController.getFooterItems(testEvent.Id);
        Test.stopTest();

   
        System.assertEquals(1, result.size());
        System.assertEquals('Facebook', result[0].socialMediaType);
        System.assertEquals('facebook.png', result[0].socialMediaIcon);
    }
}
// /**
// * @author: Aneela Oad
// * @description: Controls the logic and behavior of the navigation bar within the application.
// * @since: 20/01/24
// * @Last Modified by: Aneela Oad
// */
// @RestResource(urlMapping='/navItems/*')
// global without sharing class NavigationbarController {


//   /**
//   * @author: Aneela Oad
//   * @description: Returns the list of navigation items
//   * @param  String eventId
//   * @return: `List<DenormalizedNavigationControl> `
//   */
//   @AuraEnabled(cacheable=true)
//   @HttpGet
// global static List<DenormalizedNavigationControl> getNavigationItems( ) {
//         String eventId = RestContext.request.params.get('eventId');
//         String recordType = RestContext.request.params.get('recordType');
//         // String recordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Header Navigation').getDeveloperName();          
//         List<Navigation_Control__c> headerNavigationItemList = NavigationControlSelector.getHeaderNavigationMenu(recordType, eventId);
//         List<DenormalizedNavigationControl> denormalizedHeaderNavigationItemsList = new List<DenormalizedNavigationControl>();
 
    	 
//     for (Navigation_Control__c navigationItem : headerNavigationItemList) {
//       DenormalizedNavigationControl denormalizedMenuItem = new DenormalizedNavigationControl();

//       denormalizedMenuItem.companyLogo = navigationItem.Event__r.Event_Organizer_Company__r.Logo__c;
//       denormalizedMenuItem.menuTab = navigationItem.Menu_Item_Name__c;
//       denormalizedMenuItem.section = navigationItem.Section__c;
//       denormalizedMenuItem.socialMediaType = navigationItem.Social_Media_Type__c;
//       denormalizedMenuItem.socialMediaLink = navigationItem.Link_URL__c;

//       denormalizedHeaderNavigationItemsList.add(denormalizedMenuItem);

//     }
   
//         return denormalizedHeaderNavigationItemsList;
//     }
    
// }


/**
* @author: Aneela Oad
* @description: Controls the logic and behavior of the navigation bar within the application.
* @since: 20/01/24
* @Last Modified by: Aneela Oad
*/
public without sharing class NavigationbarController {


  /**
  * @author: Aneela Oad
  * @description: Returns the list of navigation items
  * @param  String eventId
  * @return: `List<DenormalizedNavigationControl> `
  */
  @AuraEnabled(cacheable=true)
public static List<DenormalizedNavigationControl> getNavigationItems( String eventId) {

        String recordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Header Navigation').getDeveloperName();          
        List<Navigation_Control__c> headerNavigationItemList = NavigationControlSelector.getHeaderNavigationMenu(recordType, eventId);
        List<DenormalizedNavigationControl> denormalizedHeaderNavigationItemsList = new List<DenormalizedNavigationControl>();
 
    	 
    for (Navigation_Control__c navigationItem : headerNavigationItemList) {
      DenormalizedNavigationControl denormalizedMenuItem = new DenormalizedNavigationControl();

      denormalizedMenuItem.companyLogo = navigationItem.Event__r.Event_Organizer_Company__r.Logo__c;
      denormalizedMenuItem.menuTab = navigationItem.Menu_Item_Name__c;
      denormalizedMenuItem.section = navigationItem.Section__c;
      denormalizedMenuItem.socialMediaType = navigationItem.Social_Media_Type__c;
      denormalizedMenuItem.socialMediaLink = navigationItem.Link_URL__c;

      denormalizedHeaderNavigationItemsList.add(denormalizedMenuItem);

    }
   
        return denormalizedHeaderNavigationItemsList;
    }

    @AuraEnabled(cacheable = true)
    public static String getSiteBaseURL() {
      return URL.getSalesforceBaseUrl().toExternalForm();
    }

    
}
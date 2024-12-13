/**
* @author: Aneela Oad
* @description: Controls the logic and behavior of the site's footer.
* @since: 12/01/24
* @Last Modified by: Aneela Oad
*/
public class FooterController {


    /**
    * @author: Aneela Oad
    * @description: Returns the footer links
    * @param  String eventId
    * @return: `List<DenormalizedFooter> `
    */
@AuraEnabled(cacheable=true)
public static List<DenormalizedFooter> getFooterItems( String eventId) {
     String recordType =  Schema.SObjectType.Navigation_Control__c.getRecordTypeInfosByName().get('Footer Navigation').getDeveloperName();          

    List<Navigation_Control__c> headerNavigationItemList = NavigationControlSelector.getHeaderNavigationMenu(recordType, eventId);
    List<DenormalizedFooter> denormalizedFooterItemsList = new List<DenormalizedFooter>();
    
    Map<String, String> socialMediaIconsMap = new Map<String, String>();
    
    List<Schema.PicklistEntry> picklistValues = Navigation_Control__c.Social_Media_Type__c.getDescribe().getPicklistValues();
    for (Schema.PicklistEntry pickVal : picklistValues) {
       
        socialMediaIconsMap.put(pickVal.getValue(),  pickVal.getValue().toLowerCase() + '.png');
    }

    for (Navigation_Control__c navigationItem : headerNavigationItemList) {
        DenormalizedFooter denormalizedMenuItem = new DenormalizedFooter();

        denormalizedMenuItem.socialMediaType = navigationItem.Social_Media_Type__c;
        denormalizedMenuItem.socialMediaLink = navigationItem.Link_URL__c;
    
        if (socialMediaIconsMap.containsKey(navigationItem.Social_Media_Type__c)) {
            denormalizedMenuItem.socialMediaIcon = socialMediaIconsMap.get(navigationItem.Social_Media_Type__c);
        } 

        denormalizedFooterItemsList.add(denormalizedMenuItem);
    }

    return denormalizedFooterItemsList;
}



}
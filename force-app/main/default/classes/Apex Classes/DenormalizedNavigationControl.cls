/**
* @author: Aneela Oad
* @description: Handles the denormalization process for attendee data.
* @since: 4/01/24   
* @Last Modified by: Aneela Oad
*/
global without sharing class DenormalizedNavigationControl {

@AuraEnabled public String menuTab;
@AuraEnabled public String section;
@AuraEnabled public Decimal order;
@AuraEnabled public Boolean isVisible;
@AuraEnabled public String companyLogo;
@AuraEnabled public String socialMediaLink;
@AuraEnabled public String socialMediaType;

public DenormalizedNavigationControl(){

}
}
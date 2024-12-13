/**
* @author: Muhammad Raza
* @description: Apex class for retrieving organization information
* @since: 01/01/24
* @Last Modified by: Muhammad Raza
*/

public with sharing class CompanyInformationSelector {
/**
* @author: Muhammad Raza
* @description: Retrieve organization ID using UserInfo class
* @return: `Id`
*/
    
    public  Id getOrgId(){
        
        Id orgId = UserInfo.getOrganizationId();
        return orgId;
    }
    
    /**
* @author:Muhammad Raza
* @description: This method uses the URL class to fetch the organization domain URL.
* @return: `String`
*/   
    
    public  String getOrgUrl(){
        
        string orgUrl = URL.getOrgDomainURL().toExternalForm();
        return orgUrl;
    }
}
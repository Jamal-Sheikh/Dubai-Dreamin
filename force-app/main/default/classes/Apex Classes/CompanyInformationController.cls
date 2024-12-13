/**
* 
* @author: Muhammad Raza
* @description: Apex controller for retrieving company information.
*               This class provides a method to fetch denormalized company information.
* @created: 31/01/24
* @Last Modified by: 31/01/24
*/
public without sharing class CompanyInformationController {
    /**
    * @author: Muhammad Raza
    * @description: This method utilizes the CompanyInformationSelector class to fetch the organization ID
    *               and URL.
    * @return: `DenormalizedCompanyInformation`
    */
    @AuraEnabled(cacheable=true)
    public static DenormalizedCompanyInformation getCompanyInfo(){
        
        Id orgId = new CompanyInformationSelector().getOrgId();
        String orgUrl = new CompanyInformationSelector().getOrgUrl();
        
        DenormalizedCompanyInformation  fetchingCompanyInfo= new DenormalizedCompanyInformation();
        
        fetchingCompanyInfo.orgId = orgId;
        fetchingCompanyInfo.orgUrl = orgUrl;
        
        return fetchingCompanyInfo;
        
    }
    
}
/**
* @author: Muhammad Raza
* @description: Manages the denormalization of Company Org Id and Org Url for improved performance.
* @since: 20/12/23
* @Last Modified by: Muhammad Raza
*/
public with sharing class DenormalizedCompanyInformation {
    @AuraEnabled 
    public Id orgId;
    @AuraEnabled
    public String orgUrl;
    
    public DenormalizedCompanyInformation(){}
}
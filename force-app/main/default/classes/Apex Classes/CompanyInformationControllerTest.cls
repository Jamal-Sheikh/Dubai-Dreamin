/**
* @author: Muhammad Raza
* @description: Test class for testing the CompanyInformationController class.
* @since: 01/02/24
* @Last Modified by: Muhammad Raza
*/
@isTest
public without sharing class CompanyInformationControllerTest {
    
/**
* @author: Muhammad Raza
* @description: Test method to verify the functionality of the getCompanyInfo method.
*              It verifies that the retrieved company information is not null.
*/
    
    @isTest 
    static void getCompanyInfoTesting(){
        Test.startTest();
        DenormalizedCompanyInformation companyInfo=   CompanyInformationController.getCompanyInfo();
        Test.StopTest();
        System.assertNotEquals(null, companyInfo, 'Company information should not be null');
    }
    
}
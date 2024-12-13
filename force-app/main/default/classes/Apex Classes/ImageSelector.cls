public with sharing class ImageSelector {


  public static ContentVersion getCVRecord(string cvId){
   
  ContentVersion file = [Select Id, Title, ContentDocumentId from ContentVersion where Id = : cvId];
  return file;
  }

  public static ContentDistribution getCDRecord(string cdId){
    ContentDistribution cd = [SELECT DistributionPublicUrl, ContentDownloadUrl FROM ContentDistribution WHERE Id = :cdId LIMIT 1];
    return cd;
  }

   
  public static list<Employee__c> getImageLink(string employeeId, string publicLink ){

   list<Employee__c> getEmployeeDetails = [Select Id, Profile_Image__c from Employee__c Where Id = :employeeId];
   getEmployeeDetails[0].Profile_Image__c = publicLink;

   update getEmployeeDetails;
   return getEmployeeDetails;

  }

}
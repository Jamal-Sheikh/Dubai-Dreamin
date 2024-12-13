@isTest
public with sharing class ProjectTest {
  @TestSetup
  static void DemoData(){
    Project__c Demo = new Project__c( Description__c = 'Hello', Name = 'HRM 2', Status__c = 'Active' );
      insert Demo;
      Project__c Demo1 = new Project__c(Description__c = 'Hello1', Name = 'HRM 3', Status__c ='Active');
      insert Demo1;
  }
    @isTest
    public static void ProjectTest() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/Project';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        ProjectController.getProjects( );
        System.assertEquals(200, response.statusCode);
        List<Project__c> responseProjects = (List<Project__c>)JSON.deserialize(response.responseBody.toString(),List<Project__c>.class);
        system.debug(responseProjects);
        Project__c testDataProject = [SELECT  Description__C, Name, Status__c FROM Project__c WHERE Name = 'HRM 2'];
        Project__c testDataProject1 = [SELECT  Description__C, Name, Status__c FROM Project__c WHERE Name = 'HRM 3'];
        System.assertEquals(testDataProject.Name , responseProjects[0].Name);
        System.assertEquals(testDataProject1.Name , responseProjects[1].Name);
        system.assertEquals(2, responseProjects.size( ));
    }
    @isTest
    public static void noProjectTest( ){
      Project__c testDataProject = [SELECT  Description__C, Name, Status__c FROM Project__c WHERE Name = 'HRM 2'];
      delete testDataProject;
      Project__c testDataProject1 = [SELECT  Description__C, Name, Status__c FROM Project__c WHERE Name = 'HRM 3'];
      delete testDataProject1;
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/api/Project';
        RestContext.request = request;
        RestContext.response = response;
        ProjectController.getProjects( );
         System.assertEquals(400, response.statusCode);
         string json = response.responseBody.toString( ).replaceAll('"', '');
         System.assertEquals('Found No Project', json );
    }
}
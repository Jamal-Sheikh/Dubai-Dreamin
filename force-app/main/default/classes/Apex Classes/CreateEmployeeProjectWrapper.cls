public with sharing class CreateEmployeeProjectWrapper {
    public  String employeeId;
     public   String projectId;
     public  String Description;
     public  String Status;
      public CreateEmployeeProjectWrapper(Map<String, Object>  getRequestBody) {
          employeeId = (String) getRequestBody.get('Employee_ID__c');
         projectId =  (String)  getRequestBody.get('Project_ID__c');
         Description = (String) getRequestBody.get('Description__c');
          Status  = (String) getRequestBody.get('Status__c');
      }
  }
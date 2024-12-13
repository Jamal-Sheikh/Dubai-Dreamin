@istest
global class LoginControllerTest {
    @testSetup
	static void setupTestData() {
    List<Employee__c> creEmployee = new List<Employee__c>();
    creEmployee.add(new Employee__c(
        Name = 'usame',
        Email__c = 'usama@gmailss.com',
        Mobile__c = '090078601',
        Password__c = '12345',
        UserName__c = '12345'
       
    ));
    insert creEmployee;
}
	//Login Test Methods
 @istest static void LogintestGetHttpCallout()
    {
        employee__c employee = [Select name, username__c from employee__c where Email__c = 'usama@gmailss.com' ];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
         request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
         blob body = Blob.valueof('{ "Email": "usama@gmailss.com", "Password": "12345" }');
         request.requestBody = body;
         LoginController.getEmployee();
         Blob jsonBlob = response.responseBody;
         String jsonString = jsonBlob.toString();
         Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
         string ActualResponse = string.valueOf(jsonMap);
         String ExpectedValue = '{employeeId='+employee.id+', employeeName=usame, message=Login Successful, profileImage=null, statusCode=200}';
         System.assertEquals(ExpectedValue, ActualResponse);
    }
    @istest static void loginGetCalloutInvalidInput()
    {
        employee__c employee = [Select name, Email__c,  Password__c  from employee__c where Email__c = 'usama@gmailss.com'];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{ "Email": "usama@gmailsss.com", "Password": "123425" }');
        request.requestBody = body;
        LoginController.getEmployee();
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(response.responseBody.toString());
        string jsonStringMap = string.valueOf(jsonMap);
        String ExpectedValue = '{employeeId=null, employeeName=null, message=User not found! Incorrect Email or Password, profileImage=null, statusCode=400}';
        System.assertEquals(ExpectedValue, jsonStringMap);
    }
    
    
    // SendOtp Test Methods
    @istest static void SendMailOtpTest()
    {
        employee__c employee = [Select name, Email__c,  Password__c  from employee__c where Email__c = 'usama@gmailss.com' ];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{ "Email": "usama@gmailss.com" }');
        request.requestBody = body;
        LoginOTPController.sendOtp();
        
        Blob jsonBlob = response.responseBody;
        String jsonString = jsonBlob.toString();
        String ActualValue = response.responseBody.toString();
        string jsonStringMap = string.valueOf(ActualValue);
        system.assertEquals('{"statusCode":200,"message":"Email has been sent Successfully","employeeId":"'+employee.id+'"}', ActualValue);
    }
    @istest static void SendMailInvalidTest()
    {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{ "Email": "usama@gmailss" }');
        request.requestBody = body;
        LoginOTPController.sendOtp();
        Blob jsonBlob = response.responseBody;
        String jsonString = jsonBlob.toString();
        String ActualValue = response.responseBody.toString();
        string jsonStringMap = string.valueOf(ActualValue);
        system.assertEquals('{"statusCode":400,"message":"Email send failed: Invalid Email or Email Does Not Exist","employeeId":null}', ActualValue);
    } 
    // VerifyUser Test Methods
    @istest static void verifyUserInput()
    {
        employee__c Employee = [Select name, Email__c, username__c from employee__c where Email__c = 'usama@gmailss.com' ];

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.otpCache');  
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body1 = Blob.valueof('{"Email": "'+Employee.Email__c+'"}');
        request.requestBody = body1;
        
        LoginOTPController.sendOTP();
        
        RestRequest request1 = new RestRequest();
        RestResponse response1 = new RestResponse();
        RestContext.request = request1;
        RestContext.response = response1;
        
        request1.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{"employeeId": "'+Employee.id+'","Otp": "'+sessionPartition.get(Employee.Id)+ '"}'); 
        request1.requestBody = body;
        
        UpdatePasswordController.verifyUser();
        
        String ActualValue = response1.responseBody.toString();
        system.assertEquals('{"statusCode":200,"profileImage":null,"message":"The User has been Verified Successfully","employeeName":null,"employeeId":"'+Employee.id+'"}', ActualValue);
    }
   @istest static void verifyUserExpiredOTP()
    {
        employee__c employee = [Select name, Email__c, username__c from employee__c where Email__c = 'usama@gmailss.com' ];
  
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.otpCache');
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{"employeeId": "'+employee.id+'","Otp": "123456"}');
        request.requestBody = body;
        UpdatePasswordController.verifyUser();
        String ActualValue = response.responseBody.toString();
        system.assertEquals('{"statusCode":400,"profileImage":null,"message":"The OTP has been Expired, Request for another OTP","employeeName":null,"employeeId":null}', ActualValue);
    }
    @istest static void verifyUserInvalidInput()
    {
        employee__c Employee = [Select name, Email__c from employee__c where Email__c = 'usama@gmailss.com' ];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
       Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.otpCache');
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body1 = Blob.valueof('{"Email": "'+Employee.Email__c+'"}');
        request.requestBody = body1;
        LoginOTPController.sendOTP();
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
        blob body = Blob.valueof('{"employeeId": "'+Employee.id+'","Otp": "123445"}');
        request.requestBody = body;
        UpdatePasswordController.verifyUser();
        system.debug(sessionPartition.get(Employee.Id));
        String ActualValue = response.responseBody.toString();
        system.assertEquals('{"statusCode":400,"profileImage":null,"message":"The OTP is Invalid","employeeName":null,"employeeId":null}', ActualValue);
    }
   //Update Password
   @istest static void updatePassword()
   {
        employee__c employee = [Select name, Email__c from employee__c where Email__c = 'usama@gmailss.com' ];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
		blob body = Blob.valueof('{"employeeId": "'+employee.id+'","Password": "12345789"}');
        request.requestBody = body;
       	UpdatePasswordController.updatePassword();
        String ActualValue = response.responseBody.toString();
        system.assertEquals('{"statusCode":200,"profileImage":null,"message":"The Password has been updated Successfully","employeeName":"usame","employeeId":"'+employee.id+'"}', ActualValue);
   }
   @istest static void updatePasswordInvalidInput()
   {
        employee__c employee = [Select name, Email__c from employee__c where Email__c = 'usama@gmailss.com' ];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;
        request.requestURI = 'https://cloud-172-dev-ed.develop.my.salesforce.com/services/apexrest/Employee';
		blob body = Blob.valueof('{"employeeId": "12345699","Password": "1234578"}');
        request.requestBody = body;
       	UpdatePasswordController.updatePassword();
        String ActualValue = response.responseBody.toString();
        system.assertEquals('{"statusCode":400,"profileImage":null,"message":"User does not exist or Incorrect Credential","employeeName":null,"employeeId":null}', ActualValue);
    } 
}
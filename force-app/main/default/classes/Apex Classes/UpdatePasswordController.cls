@RestResource(urlMapping='/UpdatePassword')
Global class UpdatePasswordController {  
    
    
    // VERIFY USER BY OTP
    @HttpPost
    Global static void verifyUser()
    {
        try{
            
            RestRequest request = RestContext.request;
            RestResponse response = RestContext.response;
            
            Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.otpCache');
            // Instance of wrapper Class
            LoginRequestWrapper requestJsonWrapper = (LoginRequestWrapper)JSON.deserialize(request.requestBody.toString(), LoginRequestWrapper.class);
            String Otp = requestJsonWrapper.Otp;
            String employeeId = requestJsonWrapper.employeeId;
            list<Employee__c> Employee = EmployeeSelector.verifyUserID(employeeId);
            
            ResponseBody responseObj = new ResponseBody();
            
            // Checking the coditions for OTP
            if((string)sessionPartition.get(employeeId) == null)
            {
                responseObj.employeeId = null;
                responseObj.StatusCode = 400;
                responseObj.Message = 'The OTP has been Expired, Request for another OTP';
                
                String jsonResponse = JSON.serialize(responseObj);
                response.responseBody = Blob.valueOf(jsonResponse);
                response.statusCode = 400;
            }
            else if((string)sessionPartition.get(employeeId) == Otp)
            {
                sessionPartition.remove(employeeId);
                responseObj.employeeId = employeeId;
                responseObj.StatusCode = 200;
                responseObj.Message = 'The User has been Verified Successfully';
                String jsonResponse = JSON.serialize(responseObj);
                response.responseBody = Blob.valueOf(jsonResponse);              																												
            }
            else if ((string)sessionPartition.get(employeeId) != Otp)
            {
                
                responseObj.employeeId = NULL;
                responseObj.StatusCode = 400;
                responseObj.Message = 'The OTP is Invalid';
                
                String jsonResponse = JSON.serialize(responseObj);
                response.responseBody = Blob.valueOf(jsonResponse);
                response.statusCode = 400;
            }
        }
        catch(exception e)
        {
            String jsonResponse = JSON.serialize(e.getMessage());
            Restcontext.response.responseBody = Blob.valueOf(jsonResponse);
            RestContext.response.statusCode = 400;
        }
        
        
    }
    
    // UPDATE PASSWORD OF EMPLOYEE
    @HttpPut
    Global static void updatePassword() {
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        ResponseBody responseObj = new ResponseBody();
        try {
            // Wrapper Class instance
            LoginRequestWrapper requestJsonWrapper = (LoginRequestWrapper) JSON.deserialize(request.requestBody.toString(), LoginRequestWrapper.class);
            String Password = requestJsonWrapper.Password;
            String id = requestJsonWrapper.employeeId;
            // Get Employee
            list<Employee__c> employee = EmployeeSelector.updateUserPassword(id);
            // Check if Employee is empty
            if (employee.isEmpty()) {
                
                responseObj.employeeId = null;
                responseObj.StatusCode = 400;
                responseObj.Message = 'User does not exist or Incorrect Credential';
                
                String jsonResponse = JSON.serialize(responseObj);
                response.responseBody = Blob.valueOf(jsonResponse);
                
            } else {
                
                if (employee[0].Password__c != Password)
                {
                    
                    if(Password.length() >= 8)
                    {
                        //Update Password
                        employee[0].Password__c = Password;
                        update employee;
                        
                        responseObj.employeeId = employee[0].id;
                        responseObj.StatusCode = 200;
                        responseObj.Message = 'The Password has been updated Successfully';
                        responseObj.employeeName =  employee[0].name;
                        response.statusCode = 200;
                        responseObj.profileImage = employee[0].Profile_Image__c;
                        String jsonResponse = JSON.serialize(responseObj);
                        response.responseBody = Blob.valueOf(jsonResponse);
                    }
                    else{
                        responseObj.employeeId = employee[0].id;
                        responseObj.StatusCode = 400;
                        responseObj.Message = 'Password lenght Should be greater than 8 Characters';
                        responseObj.employeeName =  employee[0].name;
                        response.statusCode = 400;
                        
                        String jsonResponse = JSON.serialize(responseObj);
                        response.responseBody = Blob.valueOf(jsonResponse);   
                    }
                    
                }
                else{
                    responseObj.employeeId = employee[0].id;
                    responseObj.StatusCode = 400;
                    responseObj.Message = 'Password should not match the old password';
                    
                    String jsonResponse = JSON.serialize(responseObj);
                    response.responseBody = Blob.valueOf(jsonResponse);
                    response.statusCode = 400; 
                }  
            }
        } catch (Exception e) {
            String jsonResponse = JSON.serialize( e.getMessage());
            RestContext.response.responseBody = Blob.valueOf(jsonResponse);
            RestContext.response.statusCode = 400;
        }
    }
    Private class ResponseBody {
        String employeeId;
        integer statusCode;
        String message;
        String profileImage;
        String employeeName;
    }
}
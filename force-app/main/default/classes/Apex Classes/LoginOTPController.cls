@RestResource(urlMapping='/SendOTP')
Global class LoginOTPController {
    
    @HttpPost
    Global static void sendOTP() {
        RestResponse response = RestContext.response;
        RestRequest request = RestContext.request;
        ResponseBody responseObj = new ResponseBody();
        try{
            // Getting Data from Request
            LoginRequestWrapper requestJsonWrapper = (LoginRequestWrapper) JSON.deserialize(request.requestBody.toString(), LoginRequestWrapper.class);
            String email = requestJsonWrapper.Email;
            // Get employee
            list<Employee__c> employee = EmployeeSelector.verifyUser(email);
            
            // Check if Employee is empty
            if (Employee.isEmpty()) {
                
                responseObj.employeeId = null;
                responseObj.statusCode = 400;
                responseObj.Message = 'Email send failed: Invalid Email or Email Does Not Exist';
                
                String jsonResponse = JSON.serialize(responseObj);
                response.responseBody = Blob.valueOf(jsonResponse);
                response.statusCode = 400;
                
            } 
            else {
                // Get OTP
                String OTP = LoginUtils.generateOTP(employee[0].id);
                list<Messaging.SendEmailResult> emailResponse = LoginUtils.sendEmail(employee[0].Email__c, OTP);
                // Email Condition
                // 
                if (emailResponse.size() > 0) {
                    response.statusCode = 200;
                    responseObj.employeeId = employee[0].id;
                    responseObj.statusCode = 200;
                    responseObj.Message = 'Email has been sent Successfully';
                    
                    String jsonResponse = JSON.serialize(responseObj);
                    response.responseBody = Blob.valueOf(jsonResponse);
                    response.statusCode = 200;
                }
            }
        }
        catch (Exception e) {
            String jsonResponse = JSON.serialize(e.getMessage());
            response.responseBody = Blob.valueOf(jsonResponse);
            response.statusCode = 400;
        }
    }
    
    Private class ResponseBody {
        String employeeId;
        integer statusCode;
        String message;
    }
    
    
}
@RestResource(urlMapping='/Employee')
global class LoginController {
    
    @HttpPost
global static void getEmployee() {
    ResponseBody responseObj = new ResponseBody();
    RestResponse response = RestContext.response;
    RestRequest request = RestContext.request;
    try {
        LoginRequestWrapper requestJsonWrapper = (LoginRequestWrapper) JSON.deserialize(request.requestBody.toString(), LoginRequestWrapper.class);
        String email = requestJsonWrapper.Email;
        String password = requestJsonWrapper.Password;
		// Get Employee
        List<Employee__c> employee = EmployeeSelector.getEmployee(email, password);
		// Check if Employee Exist
        if (employee.size() == 0) {
            response.StatusCode = 400;
            
            responseObj.StatusCode = 400;
            responseObj.employeeId = null;
            
            responseObj.Message = 'User not found! Incorrect Email or Password';
            
            String jsonResponse = JSON.serialize(responseObj);
            response.responseBody = Blob.valueOf(jsonResponse);
        }
        else if (employee.size() > 0) {
            response.statusCode = 200;
            responseObj.employeeId = employee[0].Id;
            responseObj.StatusCode = 200;
            responseObj.Message = 'Login Successful';
            responseObj.employeeName = employee[0].name;
            responseObj.profileImage = employee[0].Profile_Image__c;
            String jsonResponse = JSON.serialize(responseObj);
            response.responseBody = Blob.valueOf(jsonResponse);
        }
    } catch (Exception e) {
        String jsonResponse = JSON.serialize(e.getMessage());
        response.responseBody = Blob.valueOf(jsonResponse);
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
public class createResourceCompletionWrapper {
	
    public  String employeeID;
    public  String onboardingResourceID;
    public  String Status;
  public CreateResourceCompletionWrapper(Map<String, Object>  requestData) {
         employeeID = (String) requestData.get('EmployeeID');
         onboardingResourceID =  (String)  requestData.get('OnboardingResourceID');
         Status  = (String) requestData.get('Status');
     }
 }
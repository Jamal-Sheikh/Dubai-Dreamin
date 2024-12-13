public class LoginUtils {
    public static string generateOTP(string employeeId)
    {
        String OTP = String.valueOf(Math.round((Math.random() * (900000) + 100000))) ;
     	Cache.SessionPartition sessionPartition = Cache.Session.getPartition('local.otpCache');
     	sessionPartition.put(employeeId, OTP, 3600);
        return OTP;
    }
	public static list<Messaging.SendEmailResult> sendEmail(String toAddresses, String OTP) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[]{toAddresses});
        email.setSubject('One-Time Password (OTP) for Account Verification');
        email.setPlainTextBody('Please use this code to complete the verification process within the next 5 mintues. Your OTP is: ' +  OTP);
        list<Messaging.SendEmailResult> emailResponse = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        return emailResponse;
    }
}
public class voucherCodeGen {
    
     public static void speakersVC(String SpeakerId){
        
        List<Speaker__c>lstSpeaker= SpeakerSelector.getlstofSpeakerID(speakerId);
        system.debug(lstSpeaker);

        if(lstSpeaker.size()>0){        
        For(Speaker__c speaker:lstSpeaker){
            
            if(speaker.Approval_Status__c =='Approved'){
                speaker.Voucher_Code__c=voucherCodeGeneration();
            }else if(speaker.Approval_Status__c =='Rejected'){
                speaker.Voucher_Code__c=voucherCodeGeneration();

            }
            //update lstSpeaker
        }
    }
}
    
    
    public static String voucherCodeGeneration(){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        String randomStr='';
        while (randomStr.length() < 10) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
        randomStr += chars.substring(idx, idx+1);                        
        } 
                            system.debug(randomStr);

        return randomStr;

    }
    
   public static Blob generateAES256Key() {
    Blob key = Crypto.generateAesKey(256);
    return key;
}
    
    public static void voucherGenEncrypt(String speakerId){

		List<Speaker__c> speakers=SpeakerSelector.getlstofSpeakerID(speakerId);
        String approvalStatus = speakers[0].Approval_Status__c;
        String discountquery = 'SELECT Label, Percentage__c, Status__c FROM Discount_Percentage__mdt WHERE Status__c = :approvalStatus LIMIT 1';
        Discount_Percentage__mdt discountPercent =Database.query(discountquery);
        Map<String, String> obj = new Map<String, String>();
        obj.put('speakerId',speakers[0].id);
        obj.put('Approval Status',speakers[0].Approval_Status__c);
        obj.put('Voucher Code',speakers[0].Voucher_Code__c);
        obj.put('Percentage',String.valueOf(discountPercent.Percentage__c));
        String jsonText = JSON.Serialize(obj);
        system.debug('checking Json: '+jsonText);
        
        Blob aesKey = generateAES256Key();
        Blob blobData = Blob.valueOf(jsonText); 
        Blob encrypted = Crypto.encryptWithManagedIV('AES256', aesKey, blobData);
        String encrpytCode = EncodingUtil.base64Encode(encrypted);
        System.debug('**Voucher Code Encryption : '+encrpytCode);
        
        /*Blob decryptBlob = EncodingUtil.base64Decode(outletCode);
        Blob decrypted = Crypto.decryptWithManagedIV('AES256', aesKey, decryptBlob);
        String decryptCode = decrypted.toString();
        System.debug('** Decrypted Outlet: '+decryptCode);*/
    }    
    
    
  
}
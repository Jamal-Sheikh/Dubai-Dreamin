public with sharing class EmailUniquenessClass {
    @AuraEnabled(cacheable=true)
   public static String getEmail(Id recordId){
     return [SELECT Email FROM Lead WHERE Id=: recordId ].Email;  
   }
   
   @AuraEnabled(cacheable=true)
   public static Boolean isEmailUnique(String email , Id recordId){
     List<Lead> accReq = [SELECT Id FROM Lead WHERE Email=:email AND Id !=: recordId ];  
       return accReq.isEmpty();
   }

}
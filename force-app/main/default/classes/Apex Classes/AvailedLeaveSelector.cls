public with sharing class AvailedLeaveSelector {



    // public static List <Availed_Leaves__c> leavesAvailedGetter (String employeeId, String year){

    //     Integer intYear = Integer.valueOf(year);
    //     List <Availed_Leaves__c> currentYearLeaveAvailed = new List <Availed_Leaves__c> (); 
    
    //     try{  
    
    //        currentYearLeaveAvailed = [SELECT Name, Sick_Leaves__c, Work_From_Home_s__c, Annual_Leaves__c FROM  Availed_Leaves__c WHERE Employee_Name__c =: employeeId AND Year__c=: intYear  ];
    
    //        }
            
            
    //      catch (QueryException qe){
    
    //      //  currentYearLeaveAvailed = LeaveController.leavesAvailedCreator(employeeId,intYear);
    
    //      System.debug('The error occured is '+ qe);
                 
    //       }
              
    //       return currentYearLeaveAvailed;
    //   }





    public AvailedLeaveSelector() {

    }
}
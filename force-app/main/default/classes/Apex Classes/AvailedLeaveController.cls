@RestResource(urlMapping='/api/Availed_Leaves__c/*')

 global with sharing class AvailedLeaveController {

//     @HttpPost
//     global static void remainingLeaves() {

//     RestRequest request = RestContext.request;
//     RestResponse response = RestContext.response;
//     String employeeId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
//     Integer size = request.requestBody.size();

//     AvailedLeaveWrapper wrapper = AvailedLeaveWrapper.parse(request.requestBody.toString());
//     System.debug(wrapper);

//     Leave_Quota__mdt leaveQuotaAssigned = LeaveQuotaUtils.leaveQuotaGetter(wrapper.designation);

//     List <Availed_Leaves__c> currentYearLeaveAvailed = AvailedLeaveSelector.leavesAvailedGetter(employeeId,wrapper.year);

//     if(currentYearLeaveAvailed.size()==0)
//     {

//         String resultResponse= 'Sick leaves remaining ' +Integer.valueOf(leaveQuotaAssigned.Sick_Leaves__c)+ ', Annual leaves remaining '+Integer.valueOf(leaveQuotaAssigned.Annual_Leaves__c) + ', Work From Homes remaining ' +Integer.valueOf(leaveQuotaAssigned.Work_From_Home_s__c) ;

//         response.responseBody= Blob.valueOf(JSON.serialize(resultResponse));
//     }


//     else{

//         Integer remainingSick=Integer.valueOf(leaveQuotaAssigned.Sick_Leaves__c)-Integer.valueOf(currentYearLeaveAvailed[0].Sick_Leaves__c);
//         Integer remainingAnnual= Integer.valueOf(leaveQuotaAssigned.Annual_Leaves__c) - Integer.valueOf(currentYearLeaveAvailed[0].Annual_Leaves__c);
//         Integer remainingWorkFromHomes = Integer.valueOf(leaveQuotaAssigned.Work_From_Home_s__c) - Integer.valueOf(currentYearLeaveAvailed[0].Annual_Leaves__c);
//         String resultResponse= 'Sick leaves remaining ' +remainingSick+', Annual leaves remaining '+ remainingAnnual+ ', Work From Homes remaining ' +remainingWorkFromHomes;

//         response.responseBody= Blob.valueOf(JSON.serialize(resultResponse));
//     }


//     }


//     public static Availed_Leaves__c leavesAvailedCreator(String employeeId, String year){

//         Integer intYear=Integer.valueOf(year);
//         Availed_Leaves__c leavesAvailed = new Availed_Leaves__c ();

//         leavesAvailed.Employee_Name__c=employeeId;
//         leavesAvailed.Name='Leave ' +employeeId;
//         leavesAvailed.Sick_Leaves__c=0;
//         leavesAvailed.Work_From_Home_s__c=0;
//         leavesAvailed.Annual_Leaves__c=0;
//         leavesAvailed.Emergency_Leaves__c=0;
//         leavesAvailed.Year__c= intYear;

//         insert leavesAvailed;
    
//         return leavesAvailed;
//     }

//     public AvailedLeaveController() {

//     }
}
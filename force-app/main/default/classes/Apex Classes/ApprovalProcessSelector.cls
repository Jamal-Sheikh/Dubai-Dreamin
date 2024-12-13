/**
 * 
 * @author Faraz
 * @since 1 April 2024
 */
public with sharing class ApprovalProcessSelector {
   
    /**
     * @description returns the Approval Process records from which we can get the info about the related speaker (TargetObjectId)
     * @param whereClause 
     * @return  `List<ProcessInstance>`
     */
    public  List<ProcessInstance> getProcessInstaceList(String whereClause){
        String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
        String queryOnProcessInstance = 'SELECT Id, TargetObjectId, ProcessDefinitionId, Status ' +
            'FROM ProcessInstance '
            + clause  ;
        List<ProcessInstance> processInstance = Database.query(queryOnProcessInstance);
        return   processInstance;
    }

    /**
     * @description gets the approval process by id
     * @param id 
     * @return  `List<ProcessInstance>`
     */
    public  List<ProcessInstance> getProcessInstanceById(String id){
        String clause = 'Id  = \''+id+'\' ';
        List<ProcessInstance> selectedProcessInstances = getProcessInstaceList(clause);
        
        if (selectedProcessInstances.size() > 0) {
            return selectedProcessInstances;
        }
        return selectedProcessInstances; 
    } 


    // -------------------------------------------------------------------------


    public  List<ProcessInstanceWorkitem> getProcessInstaceWorkItemList(String whereClause){
        String clause =  String.IsEmpty(whereClause)?'':'WHERE '+whereClause;
        String queryOnProcessInstanceWorkitem = 'SELECT ProcessInstanceId, Id ' +
            'FROM ProcessInstanceWorkitem '
            + clause  ;
        List<ProcessInstanceWorkitem> processInstanceWorkItem = Database.query(queryOnProcessInstanceWorkitem);
        return   processInstanceWorkItem;
    }


    public  List<ProcessInstanceWorkitem> getProcessInstanceWorkItemById(String id){
        String clause = 'Id  = \''+id+'\' ';
        List<ProcessInstanceWorkitem> selectedProcessInstanceWorkItems = getProcessInstaceWorkItemList(clause);
        
        if (selectedProcessInstanceWorkItems.size() > 0) {
            return selectedProcessInstanceWorkItems;
        }
        return selectedProcessInstanceWorkItems; 
    }
}
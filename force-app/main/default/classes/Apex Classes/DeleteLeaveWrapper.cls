public with sharing class DeleteLeaveWrapper {



    public String leaveId;

    public static DeleteLeaveWrapper parse(String json) {
		return (DeleteLeaveWrapper) System.JSON.deserialize(json, DeleteLeaveWrapper.class);
	}


    
}
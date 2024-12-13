/**
* @author: Aneela Oad
* @description: Handles the denormalization process for Response data.
* @since: 05/01/24
* @Last Modified by:   Aneela Oad
*/
public class DenormalizedResponse {
@AuraEnabled public string questionId;
@AuraEnabled public string response;


public DenormalizedResponse(){
    
}
}
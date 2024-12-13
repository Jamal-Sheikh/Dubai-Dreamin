/**
* @author: Muhammad Raza
* @description: This Class representing denormalized information about a session.
* @since: 01/01/24
* @Last Modified by: Muhammad Raza
*/
public with sharing class DenormalizedSession {

    @AuraEnabled 
	public String sessionId;
    @AuraEnabled 
	public String sessionName;
    @AuraEnabled 
	public String sessionTitle;
    @AuraEnabled 
	public String sessionDescription;
    @AuraEnabled    
	public Date sessionStartDate;
    @AuraEnabled
	public Date sessionEndDate;
    @AuraEnabled
	public String sessionStartTime;
    @AuraEnabled
	public String sessionEndTime;
    @AuraEnabled
	public String sessionDuration;
    @AuraEnabled
	public String sessionTrack;
    @AuraEnabled
	public String sessionSelectionDetails;
    @AuraEnabled
	public String sessionExpertiseOnSubject;
    @AuraEnabled
	public String sessionIntroLink;
    @AuraEnabled
	public String sessionLevel;
    @AuraEnabled
	public String sessionPresentedLink;
    @AuraEnabled
	public Boolean sessionAlreadyPresented = false;
    @AuraEnabled
	public Boolean IPRCompliance = false;
    @AuraEnabled
	public Boolean individualPresentor = false;

    @AuraEnabled
	public List<DenormalizedSpeaker> lstOfSpeakers;



    @AuraEnabled public String speakerImage;
    @AuraEnabled public String speakerName;
    @AuraEnabled public String speakerPhone;
    @AuraEnabled public String speakerRole;
    @AuraEnabled public String speakerTarget;
    @AuraEnabled public String speakerEmail;
    @AuraEnabled public String companyName;
    @AuraEnabled public String speakerInformation;
    @AuraEnabled public String speakerSocialMedia;
    @AuraEnabled public String speakerAge;
    @AuraEnabled public String speakerGender;

    @AuraEnabled public String coSpeakerName;
    @AuraEnabled public String coSpeakerCompanyName;
    @AuraEnabled public String coSpeakerPhone;
    @AuraEnabled public String coSpeakerEmail;
    @AuraEnabled public String coSpeakerTitle;
    @AuraEnabled public String coSpeakerRole;
    @AuraEnabled public String coSpeakerImage;
    @AuraEnabled public String coSpeakerImageBlob;


    public DenormalizedSession(){}


    public void setSessionName(String sessionName){

        this.sessionName = sessionName;
    }
    public void setSessionId(String sessionId){

        this.sessionId = sessionId;
    }
    public void setStartTime(String sessionStartTime){

        this.sessionStartTime = sessionStartTime;
    }
    public void setEndTime(String sessionEndTime){

        this.sessionEndTime = sessionEndTime;
    }
    public void setSessionTitle(String sessionTitle){

        this.sessionTitle = sessionTitle;
    }
    public void setSessionDescription(String sessionDescription){

        this.sessionDescription = sessionDescription;
    }
    public void setSessionTrack(String sessionTrack){

        this.sessionTrack = sessionTrack;
    }
 
    public void setSessionSelectionDetails(String sessionSelectionDetails){

        this.sessionSelectionDetails = sessionSelectionDetails;
    }
    public void setSessionExpertiseOnSubject(String sessionExpertiseOnSubject){

        this.sessionExpertiseOnSubject = sessionExpertiseOnSubject;
    }
    public void setSessionIntroLink(String sessionIntroLink){

        this.sessionIntroLink = sessionIntroLink;
    }
    public void setSessionLevel(String sessionLevel){

        this.sessionLevel = sessionLevel;
    }
    public void setSessionPresentedLink(String sessionPresentedLink){

        this.sessionPresentedLink = sessionPresentedLink;
    }
    public void setSessionAlreadyPresented(Boolean sessionAlreadyPresented){

        this.sessionAlreadyPresented = sessionAlreadyPresented;
    }
    public void setIPRCompliance(Boolean IPRCompliance){

        this.IPRCompliance = IPRCompliance;
    }
    public void setIndividualPresentor(Boolean individualPresentor){

        this.individualPresentor = individualPresentor;
    }


    // -----------speaker-----------------------

    
    public void setSpeakerName(String speakerName){

        this.speakerName = speakerName;
    }
    public void setSpeakerPhone(String speakerPhone){

        this.speakerPhone = speakerPhone;
    }
    public void setSpeakerRole(String speakerRole){

        this.speakerRole = speakerRole;
    }
    public void setSpeakerTarget(String speakerTarget){

        this.speakerTarget = speakerTarget;
    }
    public void setSpeakerEmail(String speakerEmail){

        this.speakerEmail = speakerEmail;
    }
    public void setSpeakerCompanyName(String companyName){

        this.companyName = companyName;
    }
    public void setSpeakerInformation(String speakerInformation){

        this.speakerInformation = speakerInformation;
    }
    public void setSpeakerSocialMedia(String speakerSocialMedia){

        this.speakerSocialMedia = speakerSocialMedia;
    }
    public void setSpeakerAge(String speakerAge){

        this.speakerAge = speakerAge;
    }
    public void setSpeakerGender(String speakerGender){

        this.speakerGender = speakerGender;
    }

   // ----------- co speaker-----------------------


   public void setCoSpeakerName(String coSpeakerName){

    this.coSpeakerName = coSpeakerName;
        }

   public void setCoSpeakerCompanyName(String coSpeakerCompanyName){

    this.coSpeakerCompanyName = coSpeakerCompanyName;
        }
   public void setCoSpeakerPhone(String coSpeakerPhone){

    this.coSpeakerPhone = coSpeakerPhone;
        }
   public void setCoSpeakerEmail(String coSpeakerEmail){

    this.coSpeakerEmail = coSpeakerEmail;
        }
   public void setCoSpeakerTitle(String coSpeakerTitle){

    this.coSpeakerTitle = coSpeakerTitle;
        }
   public void setCoSpeakerRole(String coSpeakerRole){

    this.coSpeakerRole = coSpeakerRole;
        }
   public void setCoSpeakerImage(String coSpeakerImage){

    this.coSpeakerImage = coSpeakerImage;
        }


      
}
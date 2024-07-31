public With Sharing class Campaigns extends fflib_SObjectDomain
{
public Campaigns(list<Campaign> recordids){
      super(recordids);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(list<SObject> sObjectList){
            return new Campaigns(sObjectList);
        }
    } 
     Public List<Campaign>  setemailobtainforsubcribe(){
         List<Campaign>  subcribeToUpdateemail = (List<Campaign>) records;
        for (Campaign cam : subcribeToUpdateemail) {
           cam.Email_optain__c ='True' ;
        }
        return subcribeToUpdateemail;
  } 
     Public List<Campaign>  setemailobtainforunsubcribe(){
         List<Campaign>  unsubcribeToUpdateemail = (List<Campaign>) records;
        for (Campaign cam : unsubcribeToUpdateemail) {
           cam.Email_optain__c ='False' ;
        }
        return unsubcribeToUpdateemail;
  } 
    
}
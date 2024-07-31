public class Contacts extends fflib_SObjectDomain{
    public Contacts(list<Contact> recordsids){
      super(recordsids);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new Contacts(sObjectList);
        }
    }
public override void onAfterUpdate(Map<Id, SObject> existingRecords){
    Set<Id> subscribedContactIds = new Set<Id>();
    Set<Id> unsubscribedContactIds = new Set<Id>();
    for (Contact newContact : (List<Contact>) records) {
        Contact oldContact = (Contact) existingRecords.get(newContact.Id);
    system.debug('old contact :'+oldContact);
        if (oldContact != null) {
            if (newContact.Subscribed_for_All__c != oldContact.Subscribed_for_All__c) {
                if (newContact.Subscribed_for_All__c) {
                    subscribedContactIds.add(newContact.Id);
                } else {
                    unsubscribedContactIds.add(newContact.Id);
                }
            }
            if (newContact.Un_Subscribed__c != oldContact.Un_Subscribed__c) {
                if (newContact.Un_Subscribed__c) {
                    unsubscribedContactIds.add(newContact.Id);
                } else {
                    subscribedContactIds.add(newContact.Id);
                }
            }
        }
    }
    if (!subscribedContactIds.isEmpty()) {      
        Campagin_Service.updateEmailObtain(subscribedContactIds); 
    }   
    if (!unsubscribedContactIds.isEmpty()) {
        Campagin_Service.updateEmailObtain(unsubscribedContactIds); 
    }
}    
    Public Void updateFirstName(String fname){
      List<Contact>  contacts =  (List<Contact>) records ;
        for(Contact  con : contacts){
            con.firstname = fname;
            break;
        }
    }
    Public Void  updateLastname(String lname){
       List<Contact>  contacts =  (List<Contact>) records ;
        for(Contact  con : contacts){
            con.Lastname = lname;
            break;
        } 
    }    
  
  
 
    
    
    
    
    
    
    
    
    

 /*   
    public override void onAfterDelete(){
        Set<Id> conIds = new Set<Id>();
        for (Contact c : (List<Contact>) records) {
            if (c.ID!= null){
                conIds.add(c.ID);
            }
        }
        if (!conIds.isEmpty()) {
           Campagin_Service.updateemailobtain(conIds);
        }
    }
    public override void onAfterUndelete() {
       Set<Id> conIds = new Set<Id>();
        for (Contact c : (List<Contact>) records) {
            if (c.ID != null){
                conIds.add(c.ID);
            }
        }
        if (!conIds.isEmpty()) {
            Campagin_Service.updateemailobtain(conIds);
        }
    }
*/
   
}
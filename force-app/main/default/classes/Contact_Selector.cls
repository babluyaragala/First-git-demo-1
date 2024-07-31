public class Contact_Selector extends fflib_SobjectSelector{
    public Schema.SobjectType getsobjectType(){
         return Contact.SobjectType;
     }    
    public List<Schema.Sobjectfield>  getSobjectfieldlist(){
        return new List<Schema.Sobjectfield>{
                Contact.id,
                Contact.lastname,
                Contact.phone,
                    Contact.Accountid};
    }
    public List<Contact>  Selectbyid(Set<id>  idset){
        return (List<Contact>) SelectSobjectsbyid(idset);
    }
    public List<Contact> selectcampaignsforsubscribed(Set<Id> contactIds){
		return (List<Contact>) Database.query(
			newQueryFactory().selectField(Contact.Subscribed_for_All__c). 
				          	setCondition('Subscribed_for_All__c = true').                          
					           toSOQL());
	}
}   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     public List<Contact> selectcampaignsforunsubscribed(Set<Id> contactIds){
		return (List<Contact>) Database.query(
			newQueryFactory().selectField(Contact.Subscribed_for_All__c). 
				          	setCondition('Un_Subscribed__c = true').                          
					           toSOQL());
	}
    /*
     public List<Contact> selectcampaignsforsubscribed(Set<Id> contactIds){
      fflib_QueryFactory query = newQueryFactory();
      query.setCondition(' Id IN :contactIds');
      new Contact_Selector().
            addQueryFactorySubselect(query,'Campaign');
      return (List<Contact>) Database.query(query.toSOQL());
   } 
    public List<Contact> selectcampaignsforunsubscribed(Set<Id> contactIds){
      fflib_QueryFactory query = newQueryFactory();
      query.setCondition('Un_Subscribed__c = true AND Id IN :contactIds');
      new Contact_Selector().
            addQueryFactorySubselect(query,'Campaign');
      return (List<Contact>) Database.query(query.toSOQL());
   }
*/
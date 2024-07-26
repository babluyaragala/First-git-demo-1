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
    public List<Contact> selectContactbyemail(Set<String> emails){
		return (List<Contact>) Database.query(
			newQueryFactory().selectField(Contact.Firstname).
                           selectField(Contact.LastName).
                           selectField(Contact.email). 
				          	setCondition('Email IN :emails').
                          setLimit(1). 
					           toSOQL());
	}
}
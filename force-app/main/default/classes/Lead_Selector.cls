public class Lead_Selector extends fflib_SobjectSelector{
     public Schema.SobjectType getsobjectType(){
         return Lead.SobjectType;
     }    
    public List<Schema.Sobjectfield>  getSobjectfieldlist(){
        return new List<Schema.Sobjectfield>{
                Lead.Lastname,
                Lead.Firstname,
                Lead.phone};
    }
    public List<Lead>  Selectbyid(Set<id>  idset){
        return (List<Lead>) SelectSobjectsbyid(idset);
    }
    
    public List<Lead> selectleadbyemail(Set<String> emails){
		return (List<Lead>) Database.query(
			newQueryFactory().selectField(Lead.Firstname).
                           selectField(Lead.LastName).
                           selectField(Lead.email). 
				          	setCondition('Email IN :emails').
                          setLimit(1). 
					           toSOQL());
	}
}
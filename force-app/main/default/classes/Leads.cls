public class Leads extends fflib_SobjectDomain {
    public Leads(List<Lead> leadrecords) {
        super(leadrecords);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Leads(sObjectList);
        }
    }
     public static void validateLead(String email, String lastName) {
        if (String.isBlank(email) || String.isBlank(lastName)) {
            throw new Lead_Exception('LastName and Email are mandatory fields.');
        }
    }
    public void updateFirstName(String fname) {
        List<Lead> leads = (List<Lead>) records;
        for (Lead lead : leads){ 
                lead.FirstName = fname;
                break;            
        }
    } 
    public void updateLastName(String lname){
        List<Lead> leads = (List<Lead>) records;
        for (Lead lead : leads) {           
                lead.LastName = lname;
                break;            
        }
    }
}
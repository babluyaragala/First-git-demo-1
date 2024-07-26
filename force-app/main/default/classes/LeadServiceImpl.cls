public class LeadServiceImpl implements LeadServiceInterface {
    public void upsertLead(String fname, String lname, String email){
        Lead_Service.Leadupserting(fname, lname, email);
    }
}
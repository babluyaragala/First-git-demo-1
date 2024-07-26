public with sharing class LeadFactory {
    public  List<lead> insertLead(String fname, String lname, String email){        
        List<lead> newLeadrecord = new List<lead>();
          lead newlead  = new lead();
        newlead.FirstName = fname;
        newlead.LastName = lname;
        newlead.Email = email;
        newlead.Company = 'Unknown';
        newLeadrecord.add(newlead);
        return newLeadrecord;         
    }
}
@RestResource(URLMapping='/Leadservicehelper/*')
global class Leadwebservice 
{

    @HttpPatch
    global static void leadupsert(String Fname, String Lname, String email) 
    {
       try 
       {
        if (String.isBlank(Lname) || String.isBlank(email))
        {
            throw new UserException('Lname and Email are the mandatory feild .');
        }

        List<Lead> lerecords = new List<Lead>();
        
        List<Lead> leads = [SELECT Id, LastName, FirstName, Email 
                            FROM Lead 
                            WHERE Email = :email 
                            LIMIT 1];

        if (!leads.isEmpty()) 
        {
            Lead existingLead = leads[0];
            existingLead.FirstName = Fname;
            existingLead.LastName = Lname;
            
            lerecords.add(existingLead);
        } 
        else 
        {
            Lead newLead = new Lead();
            newLead.FirstName = Fname;
            newLead.LastName = Lname;
            newLead.Email = email;
            newLead.Company = 'Unknown'; 
            
            lerecords.add(newLead);
        }
        
        if (!lerecords.isEmpty()) 
        {
            upsert lerecords;
            
            if (leads.isEmpty()) 
            {
                Lead newLead = lerecords[0];

                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(newLead.Id);
                
                lc.setDoNotCreateOpportunity(true); 

                String convertedStatus =LeadConversionHelper.getConvertedStatus();

                if (convertedStatus != null) 
                {
                    lc.setConvertedStatus(convertedStatus);

                    
                    Database.LeadConvertResult lcr = Database.convertLead(lc);

                    if (lcr.isSuccess()) 
                    {
                       throw new UserException('Lead Record Upserted and Converted Successfully. New Contact ID: ' + lcr.getContactId());
                    } 
                    else 
                    {
                        throw new UserException('Lead Record Upserted, but conversion failed: ' + lcr.getErrors()[0].getMessage());
                    }
                } 
                else 
                {
                    throw new UserException('Lead Record Upserted, but no valid converted status found.');
                }
            }
            else 
            {   
                throw new UserException('Lead Record Upserted Successfully. Lead ID: ' + lerecords[0].Id);
            }
        } 
        else 
        {
           throw new UserException('Upsert Operation Failed.');
        }
       }
           catch (UserException e) 
           {
            
            RestContext.response.responseBody = Blob.valueOf(e.getMessage());
        }
           catch (Exception e) 
        {
       
            RestContext.response.responseBody = Blob.valueOf('An error occurred: ' + e.getMessage());
        }
    }
}
/*
 *  public static void upsertLead(String Fname, String Lname, String email) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();
       
        Lead_Selector leadSelector = (Lead_Selector) Application.Selector.newInstance(Lead.SObjectType);

        Set<String> emailSet = new Set<String>{email};
            
        List<Lead> existingLeads = leadSelector.selectLeadByEmail(emailSet);

        Map<String, Lead> emailToLeadMap = new Map<String, Lead>();
        for (Lead existingLead : existingLeads) {
            emailToLeadMap.put(existingLead.Email, existingLead);
        }

        List<Lead> leadsToUpdate = new List<Lead>();
        List<Lead> leadsToCreate = new List<Lead>();

        if (emailToLeadMap.containsKey(email)) {
            Lead existingLead = emailToLeadMap.get(email);
            existingLead.FirstName = Fname;
            existingLead.LastName = Lname;
            leadsToUpdate.add(existingLead);
        } else {
            Lead newLead = new Lead();
            newLead.FirstName = Fname;
            newLead.LastName = Lname;
            newLead.Email = email;
            newLead.Company = 'Unknown';
            leadsToCreate.add(newLead);
        }
        if (!leadsToUpdate.isEmpty()) {
            unitOfWork.registerDirty(leadsToUpdate);
        }
        if (!leadsToCreate.isEmpty()) {
            unitOfWork.registerNew(leadsToCreate);
        }
        unitOfWork.commitWork();
        
        if (!leadsToCreate.isEmpty()) {
            LeadFactory.convertLead(leadsToCreate, email);
        } else {
            LeadFactory.convertLead(leadsToUpdate, email);
        }
    }
 * */
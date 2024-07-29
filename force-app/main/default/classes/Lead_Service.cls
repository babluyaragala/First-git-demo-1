public with sharing class Lead_Service {
    public static void Leadupserting(String fname, String lname, String email) {
        Lead_Selector leadSelector = (Lead_Selector) Application.selector.newInstance(Lead.SObjectType);       
        Set<String> emailSet = new Set<String>{email};
        List<Lead> existingLeads = leadSelector.selectLeadByEmail(emailSet);
        if (existingLeads == null) {
            existingLeads = new List<Lead>();}
        System.debug('Existing leads: ' + existingLeads);
        fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();        
        Leads domain = (Leads) new Leads.Constructor().construct(existingLeads);     
        if (!existingLeads.isEmpty()) {
            Lead existingLead = existingLeads[0];
            if (existingLead != null) {
                System.debug('Updating existing lead: ' + existingLead);         
                domain.updateFirstName(fname);
                domain.updateLastName(lname);
                unitOfWork.registerDirty(existingLead);
                unitOfWork.commitWork();
                System.debug('Existing lead updated and committed.');
                convertLead(existingLeads);
            } else {
                throw new Lead_Exception('Existing lead record is null.');
            }
        } else {
            List<Lead> newlead = new LeadFactory().insertLead(fname, lname, email);
            if (newlead != null) {
                System.debug('New lead created: ' + newlead);
                unitOfWork.registerNew(newlead);
                unitOfWork.commitWork();
                System.debug('New lead registered and committed.');
                convertLead(newlead);
            } else {
                throw new Lead_Exception('Failed to create a new lead.');
            }
        }        
    }
    private static void convertLead(List<Lead> leads) {
        if (leads != null && !leads.isEmpty()) {
            Lead newlead = leads[0];
            if (newLead != null) {
                System.debug('Converting lead: ' + newLead);
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(newLead.Id);
                lc.setDoNotCreateOpportunity(true);
                String convertedStatus = LeadConversionHelper.getConvertedStatus();
                if (convertedStatus != null) {
                    lc.setConvertedStatus(convertedStatus);
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    if (lcr.isSuccess()) {
                        System.debug('Lead converted successfully. New Contact ID: ' + lcr.getContactId());
                        throw new Lead_Exception('Lead Record Upserted and Converted Successfully. New Contact ID: ' + lcr.getContactId());
                    } else {
                        System.debug('Lead conversion failed: ' + lcr.getErrors()[0].getMessage());
                        throw new Lead_Exception('Lead Record Upserted, but conversion failed: ' + lcr.getErrors()[0].getMessage());
                    }
                } else {
                    System.debug('No valid converted status found.');
                    throw new Lead_Exception('Lead Record Upserted, but no valid converted status found.');
                }
            } else {
                throw new Lead_Exception('No lead found to convert.');
            }
        } else {
            throw new Lead_Exception('No leads available for conversion.');
        }
    }
}
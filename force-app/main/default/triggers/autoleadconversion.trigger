trigger autoleadconversion on Lead (before insert) 
{
  
 if(Trigger.IsAfter && Trigger.IsUpdate)
    {
        LeadStatus lStatus = [Select ID, MasterLabel, IsConverted
                             				from LeadStatus
                             					Where IsConverted = true];
        
        List<Database.LeadConvert> leadRecordsToConvert = new List<Database.LeadConvert>();
        
        for(Lead ldRecord : Trigger.New)
        {
            if(ldRecord.Status == 'Closed - Converted' && ldRecord.IsConverted == False)
            {
                Database.LeadConvert lConvert = new Database.LeadConvert();
                
                	lConvert.SetLeadId(ldRecord.Id);
                
                	lConvert.SetDoNotCreateOpportunity(false);
                
                	lConvert.SetSendNotificationEmail(true);
                
                //	lConvert.SetConvertedStatus(lStatus.MasterLabel);
                
                // Add it to the List Collection..
                leadRecordsToConvert.Add(lConvert);
            }
        }
        
        if(! leadRecordsToConvert.isEmpty())
        {
            Database.LeadConvertResult[] results =	Database.ConvertLead(leadRecordsToConvert, true);
        }
    }

}
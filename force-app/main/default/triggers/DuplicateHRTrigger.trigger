trigger DuplicateHRTrigger on Hiring_Manager__c (before insert) 
{
    	if(Trigger.isInsert && Trigger.isBefore)
    {
        for(Hiring_Manager__c hrRecord : Trigger.New)
        {
            Integer recordsCount = [Select count() from Hiring_Manager__c
                                   		Where Name =: hrRecord.Name and
                                   				Contact_Number__c =: hrRecord.Contact_Number__c and
                                   					Email_Address__c =: hrRecord.Email_Address__c];
            
           	if(recordsCount > 0)
                hrRecord.AddError('Duplicate Records Found with Same Details. Hence, Record Cannot be Inserted.');
        }
    }

}
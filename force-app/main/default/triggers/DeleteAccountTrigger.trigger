trigger DeleteAccountTrigger on Account (before delete) 
{
    if(Trigger.isBefore && Trigger.IsDelete)
    {
        for(Account accRecord : Trigger.Old)
        {
            if(accRecord.Active__c == 'Yes')
                accRecord.AddError('You are Not Authorized to Delete an Active Account.');
        }
    }

}
trigger NewandUpdatedvalue on Contact (After update) 
{
    if (Trigger.isAfter && Trigger.isUpdate) 
    {  
        for (Contact oldCon : Trigger.old) 
        {
            Contact newCon = Trigger.newMap.get(oldCon.Id);
         
            System.debug('Old Lastname: ' + oldCon.LastName);
            System.debug('New Lastname: ' + newCon.LastName);
        }
    }
}
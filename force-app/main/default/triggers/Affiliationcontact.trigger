trigger Affiliationcontact on Contact (after insert, after update)
{
    if (Trigger.isAfter && Trigger.isInsert) 
    {
        List<Affiliation__c> affiliateRecords = new List<Affiliation__c>();
        Set<Id> accountIds = new Set<Id>();
        for (Contact conRecord : Trigger.new)
        {
            if (conRecord.AccountId != null)
            {
                accountIds.add(conRecord.AccountId);
            }
        }
        
       
        Map<Id, Account> accountIdToAccountMap = new Map<Id, Account>([SELECT Id, Email__c FROM Account WHERE Id IN :accountIds]);
        
        for (Contact conRecord : Trigger.new) 
        {
            if (conRecord.AccountId != null ) 
            {
                Account relatedAccount = accountIdToAccountMap.get(conRecord.AccountId);
                
                Affiliation__c affrec = new Affiliation__c();
                affrec.Account__c = conRecord.AccountId;
                affrec.Contact__c = conRecord.Id;
                
                if (conRecord.Email != null && conRecord.Email == relatedAccount.Email__c) 
                {
                    affrec.Account_OwnerShip__c = true;
                    affrec.Functions__c = 'Order Status;Administer'; 
                } else {
                    affrec.Account_OwnerShip__c = false;
                    affrec.Functions__c = 'Order Status'; 
                }
                
                affiliateRecords.add(affrec);
            }
        }
        
        if (!affiliateRecords.isEmpty()) 
        {
            insert affiliateRecords;
        }
    }
    
   
if (Trigger.isAfter && Trigger.isUpdate) 
{
    List<Affiliation__c> affiliateRecordToUpdate = new List<Affiliation__c>();
    
           for (Contact newContact : Trigger.new) 
          {
                Contact oldContact = Trigger.oldMap.get(newContact.Id);
        
          Affiliation__c existingAff = [SELECT Id FROM Affiliation__c WHERE Contact__c = :newContact.Id LIMIT 1];
        
        if ((oldContact.Email != newContact.Email || oldContact.AccountId != newContact.AccountId) && newContact.AccountId != null)
        {
           
            if (existingAff != null)
            
            {
                existingAff.Account__c = newContact.AccountId;
                affiliateRecordToUpdate.add(existingAff);
            } 
            else 
            {
                Affiliation__c newAffiliation = new Affiliation__c();
                newAffiliation.Account__c = newContact.AccountId;
                newAffiliation.Contact__c = newContact.Id;
                affiliateRecordToUpdate.add(newAffiliation);
            }
        }
      }
    if (!affiliateRecordToUpdate.isEmpty()) 
    {
        update affiliateRecordToUpdate;
    }
}


}
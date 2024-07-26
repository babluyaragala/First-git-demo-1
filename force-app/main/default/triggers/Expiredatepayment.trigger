trigger Expiredatepayment on Payment_Detail__c (before insert ,before update)
{
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate))
    {
        For(Payment_Detail__c    pdrecord  :Trigger.New)
        {
            if(pdrecord.Expire_Date__c < System.today())
            {
                pdrecord.Status__c = 'Expired';
                
            }
            else
            {
                pdrecord.Status__c ='Active';
            }
        }
    }

}
/*
trigger Affliationcontact on Contact (after insert, after update) {
    List<Affiliation__c> affiliateRecords = new List<Affiliation__c>();
    
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Email FROM Account
                                                        WHERE Id IN (SELECT AccountId FROM Contact WHERE Id IN :Trigger.new)]);
    
    for(Contact conRecord : Trigger.new) {
        if (conRecord.AccountId != null && accountMap.containsKey(conRecord.AccountId))
        {
            Account relatedAccount = accountMap.get(conRecord.AccountId);
            if (conRecord.Email != null && conRecord.Email == relatedAccount.Email) 
            {
                Affiliation__c affrec = new Affiliation__c();
                affrec.Account__c = conRecord.AccountId;
                affrec.Contact__c = conRecord.Id;
                affrec.Account_OwnerShip__c = true;
                affrec.Functions__c = 'Order Status;Administer'; // Assuming Functions__c is a multi-select picklist
                affiliateRecords.add(affrec);
            } else {
                Affiliation__c affrec = new Affiliation__c();
                affrec.Account__c = conRecord.AccountId;
                affrec.Contact__c = conRecord.Id;
                affrec.Account_OwnerShip__c = false;
                affrec.Functions__c = 'Order Status';
                affiliateRecords.add(affrec);
            }
        }
    }
    
    if (!affiliateRecords.isEmpty()) {
        insert affiliateRecords;
    }
}
trigger Affliationcontact on Contact (After insert , After Update) 
{
     List<Affiliation__c> affiliateRecords = new List<Affiliation__c>();
    
  for(Contact conRecord : Trigger.New )
  {
    if(conRecord.AccountId != Null)
    {
        Affiliation__c affrec = new Affiliation__c();
     
         IF( affrec.Account_OwnerShip__c == True)
         {
              affrec.Account__c = conRecord.AccountId;
              affrec.Contact__c =conRecord.Id; 
          
              affrec.Functions__c = 'Order Status ,Administer';
             
              affiliateRecords.add(affrec);
         }
       else
         {
              affrec.Account__c = conRecord.AccountId;
              affrec.Contact__c =conRecord.Id;
             
              affrec.Functions__c = 'Order Status';
             
              affiliateRecords.add(affrec);
         }
    }
  }
     if (!affiliateRecords.isEmpty())
     {
        insert affiliateRecords;
    }

}
trigger Affiliationcontact on Contact (after insert, after update) {
    List<Affiliation__c> affiliateRecords = new List<Affiliation__c>();

    if (Trigger.IsBefore && Trigger.IsInsert) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact conRecord : Trigger.new) {
            if (conRecord.AccountId != null) {
                accountIds.add(conRecord.AccountId);
            }
        }

        List<Account> accountslist = [SELECT Id, Email__c FROM Account WHERE Id IN :accountIds];

        for (Contact conRecord : Trigger.new) {
            Account relatedAccount = null;
            for (Account acc : accountslist) {
                if (acc.Id == conRecord.AccountId) {
                    relatedAccount = acc;
                    break;
                }
            }
            if (conRecord.AccountId != null) {
                Affiliation__c affrec = new Affiliation__c();
                affrec.Account__c = conRecord.AccountId;
                affrec.Contact__c = conRecord.Id;

                if (conRecord.Email != null && conRecord.Email == relatedAccount.Email__c) {
                    affrec.Account_OwnerShip__c = true;
                    affrec.Functions__c = 'Order Status;Administer';
                    affiliateRecords.add(affrec);
                } else {
                    affrec.Account_OwnerShip__c = false;
                    affrec.Functions__c = 'Order Status';
                    affiliateRecords.add(affrec);
                }
            }
        }
    }

    if (Trigger.IsBefore && Trigger.IsUpdate) {
        for (Contact newContact : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(newContact.Id);

            // Check if email or AccountId has changed
            if ((oldContact.Email != newContact.Email || oldContact.AccountId != newContact.AccountId)) {
                Affiliation__c aff = new Affiliation__c();
                aff.Contact__c = newContact.Id;
                aff.Account__c = newContact.AccountId;
                affiliateRecords.add(aff);
            }
        }
    }

    // Perform DML operation only if there are records to insert or update
    if (!affiliateRecords.isEmpty()) {
        if (Trigger.IsBefore && Trigger.IsInsert) {
            insert affiliateRecords;
        } else if (Trigger.IsBefore && Trigger.IsUpdate) {
            update affiliateRecords;
        }
    }
}
trigger Affiliationcontact on Contact (after insert, after update) {
    List<Affiliation__c> affiliateRecords = new List<Affiliation__c>();
    
    // For Before Insert Context
    if (Trigger.isBefore && Trigger.isInsert) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact conRecord : Trigger.new) {
            if (conRecord.AccountId != null) {
                accountIds.add(conRecord.AccountId);
            }
        }
        
        List<Account> accountslist = [SELECT Id, Email__c FROM Account WHERE Id IN :accountIds];
        
        for (Contact conRecord : Trigger.new) {
            Account relatedAccount = null;
            for (Account acc : accountslist) {
                if (acc.Id == conRecord.AccountId) {
                    relatedAccount = acc;
                    break;
                }
            }
            
            if (conRecord.AccountId != null) {
                Affiliation__c affrec = new Affiliation__c();
                affrec.Account__c = conRecord.AccountId;
                affrec.Contact__c = conRecord.Id;
                
                if (conRecord.Email != null && conRecord.Email == relatedAccount.Email__c) {
                    affrec.Account_OwnerShip__c = true;
                    affrec.Functions__c = 'Order Status;Administer'; 
                } else {
                    affrec.Account_OwnerShip__c = false;
                    affrec.Functions__c = 'Order Status'; 
                }
                
                affiliateRecords.add(affrec);
            }
        }
        
        if (!affiliateRecords.isEmpty()) {
            insert affiliateRecords;
        }
    }
    
    // For Before Update Context
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Contact newContact : Trigger.new) {
            Contact oldContact = Trigger.oldMap.get(newContact.Id);
            
            if ((oldContact.Email != newContact.Email || oldContact.AccountId != newContact.AccountId) && newContact.AccountId != null) {
                Affiliation__c aff = new Affiliation__c();
                aff.Account__c = newContact.AccountId;
                aff.Contact__c = newContact.Id;
                affiliateRecords.add(aff);
            }
        }
        
        if (!affiliateRecords.isEmpty()) {
            update affiliateRecords;
        }
    }
}

*/
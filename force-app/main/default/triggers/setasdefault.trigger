trigger setasdefault on Payment_Detail__c (Before insert ,Before update) 
{
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate) ) 
    {
        Set<Id> accountIds = new Set<Id>();
    
        for (Payment_Detail__c newCard : Trigger.new) 
        {
            accountIds.add(newCard.Account__c);
        }
        
         Map<Id, Payment_Detail__c> defaultDetailsMap = new Map<Id, Payment_Detail__c>();

        for (Payment_Detail__c detail : [SELECT Id, Account__c, set_as_default__c
                                                         FROM Payment_Detail__c
                                                      WHERE Account__c IN :accountIds
                                                        AND set_as_default__c = 'Yes']) {
            defaultDetailsMap.put(detail.Account__c, detail);
        }

        for (Payment_Detail__c pdrecord : Trigger.new)
        {
            Payment_Detail__c existingDefault = defaultDetailsMap.get(pdrecord.Account__c);
            
            if (pdrecord.set_as_default__c =='Yes' && existingDefault.Id != pdrecord.Id)
            {
                pdrecord.addError('Only one default card is allowed per account.');
            }
          system.debug(existingDefault);
            system.debug('hello');
            
        }
    }
    /*
    trigger updateAccountWithContactCount on Contact (after insert, after update, after delete, after undelete) {
    // Set to track account IDs that need updating
    Set<Id> accountIds = new Set<Id>();

    // Collect Account IDs from Trigger context
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact c : Trigger.new) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
    }
    if (Trigger.isUpdate || Trigger.isDelete) {
        for (Contact c : Trigger.old) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
    }

    // Remove duplicate entries
    accountIds.remove(null);

    // If there are accounts to process
    if (!accountIds.isEmpty()) {
        // Query the total number of contacts for each account in the set
        List<AggregateResult> contactCounts = [
            SELECT AccountId, COUNT(Id) totalContacts
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ];
        
        // Create a map to hold account updates
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();

        // Prepare accounts with their respective contact counts
        for (AggregateResult ar : contactCounts) {
            Id accountId = (Id) ar.get('AccountId');
            Integer totalContacts = (Integer) ar.get('totalContacts');
            
            Account acc = new Account(
                Id = accountId,
                Number_of_Contacts__c = totalContacts // Replace with your custom field
            );
            
            accountsToUpdateMap.put(accountId, acc);
        }
        
        // Handle accounts that have zero contacts
        for (Id accountId : accountIds) {
            if (!accountsToUpdateMap.containsKey(accountId)) {
                Account acc = new Account(
                    Id = accountId,
                    Number_of_Contacts__c = 0 // Replace with your custom field
                );
                accountsToUpdateMap.put(accountId, acc);
            }
        }

        // Convert the map values to a list and update accounts
        if (!accountsToUpdateMap.isEmpty()) {
            update accountsToUpdateMap.values();
        }
    }
}

      Map<Id, Customer> orderstatusMap = Trigger.newmap;
    
    for (Id cusid : orderstatusMap.keySet()) 
    {
        Customer newcustomer = orderstatusMap.get(cusid);
        
        if(newcustomer.)
        
    }


*/
}
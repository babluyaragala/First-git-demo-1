trigger countofContacts on Contact (after insert, after update, after delete, after undelete){    
    Set<Id> accountIds = new Set<Id>();   
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)){
        for (Contact c : Trigger.new){
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
    }   
    if (Trigger.isAfter && (Trigger.isUpdate || Trigger.isDelete)){
        for (Contact c : Trigger.old) {
            if (c.AccountId != null) 
            {
                accountIds.add(c.AccountId);
            }
        }
    }    
    if (accountIds.isEmpty()) 
    {
        return;
    }  
    List<Account> accountsToUpdate = [ SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts)
                                                                                          FROM Account
                                                                                              WHERE Id IN :accountIds ];    
    for (Account acc : accountsToUpdate) 
    {
        acc.Number_of_Contacts__c = acc.Contacts.size();
    }

    if (!accountsToUpdate.isEmpty()) 
    {
        update accountsToUpdate;
    }
}
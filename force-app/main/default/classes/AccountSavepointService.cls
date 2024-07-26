@RestResource(URLMapping='/AccountContactService/')
global class AccountSavepointService 
{
    @HttpPost
    global static void createAccountWithContact(String jsonBody) 
    {
        RestResponse response = RestContext.response;
      
               savepoint   sp = Database.setSavepoint();
        
        try 
        {  
            AccountContactDTO dto = (AccountContactDTO) JSON.deserialize(jsonBody, AccountContactDTO.class);
            
              if (String.isBlank(dto.accountName))
              {
            throw new UserException('Account name is required.');
              }
        if (String.isBlank(dto.contactFirstName) || String.isBlank(dto.contactLastName) || String.isBlank(dto.contactEmail)) 
        {
            throw new UserException('All contact fields (first name, last name, email) are required.');
        }
            
            Account newAccount = new Account();
            newAccount.Name = dto.accountName;
            insert newAccount;

          
            Contact newContact = new Contact();
            newContact.FirstName = dto.contactFirstName;
            newContact.LastName = dto.contactLastName;
            newContact.Email = dto.contactEmail;
            newContact.AccountId = newAccount.Id;
            insert newContact;

            response.responseBody = Blob.valueOf(JSON.serialize(dto));
            
           throw new UserException('Account and Contact created successfully.' + newAccount.Id + '&' + newContact.Id );

        } 
        catch (Exception e) 
        {
            
           Database.rollback(sp);
           
            response.responseBody = Blob.valueOf('Transaction rolled back due to: ' + e.getMessage());
        }
    }
}























/*
trigger countofContacts on Contact (after insert, after update, after delete, after undelete) 
{
    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isAfter) 
    {
        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)
        {
            for (Contact c : Trigger.new) 
            {
                if (c.AccountId != null) 
                {
                    accountIds.add(c.AccountId);
                }
            }
        }
        
        if (Trigger.isUpdate || Trigger.isDelete) 
        {
            for (Contact c : Trigger.old) 
            {
                if (c.AccountId != null) 
                {
                    accountIds.add(c.AccountId);
                }
            }
        }
    }
    if (accountIds.isEmpty()) 
    {
        return;
    }
   
    List<AggregateResult> contactCounts = [SELECT AccountId, COUNT(Id) contactCount
                                                                          FROM Contact
                                                                             WHERE AccountId IN :accountIds
                                                                                      GROUP BY AccountId];
    
    Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
    
    for (AggregateResult ar : contactCounts) 
    {
        accountContactCountMap.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
    }
    
    List<Account> accounts = new List<Account>();
    
    for (Id accountId : accountIds) 
    {
        Integer count; 
        if (accountContactCountMap.containsKey(accountId)) 
        { 
            count = accountContactCountMap.get(accountId); 
        } else 
        { 
            count = 0;
        } 
        
        Account acc = new Account(
            Id = accountId,
            Number_of_Contacts__c = count
        );
        accounts.add(acc);
    }
    if (!accounts.isEmpty()) 
    {
        update accounts;
    }
}
*/
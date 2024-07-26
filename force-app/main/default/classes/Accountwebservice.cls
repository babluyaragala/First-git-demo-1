@RestResource(URLMapping='/AccountService/*')
Global class Accountwebservice 
{
    @HttpGet()
    Global Static List<Case> Getallaccountrecords()
    {
        Map<String , String>    stAcc = Restcontext.request.params;
        
         List<Case> caseRecord = [Select id, caseNumber, status, type, priority, origin,
        							Reason, Subject, Description
        									from Case
                            Where Priority =: stAcc.get('pri')];
        
   
        return caseRecord;
    }
    @HttpDelete()
    Global Static String DeleteAccountrecords()
    {
        Map<String , String>   Accparams = RestContext.request.Params;
        
        List<Account> stAccounts = [Select id, name, rating, industry
                                    				from Account
                                                          Where Name =:Accparams.Get('accname')];
        
        If(! stAccounts.isEmpty())
        {
            Delete stAccounts;
            
            return 'records Deleted';
        }
        else
            Return 'Records not found';
                                     
        
    }
 //   @HttpPost()
    Global static String CreateNewContact(string fName, string lName, string cTitle, string cEmail, string cPhone, string cFax, string cMobile, string cCity, string cState, string cCountry)
    {
        Contact con = new Contact();
        	con.FirstName = fName;
        	con.LastName = lName;
        	con.Title = cTitle;
        	con.Email = cEmail;
        	con.Phone = cPhone;
        	con.Fax = cFax;
        	con.MobilePhone = cMobile;
        	con.MailingCity = cCity;
        	con.MailingState = cState;
        	con.MailingCountry = cCountry;
        
        insert con;
        
        if(con.Id != null)
        {
            return 'Contact Record Created with ID..: '+ con.Id;
        }
        else
            return 'Contact Record Creation has been Failed.';
        	
    }
    	@HttpPost()
    Global static String CreateBulkLeadRecords()
    {
        string leadRecordDetails = RestContext.request.requestbody.ToString();
        
        List<Lead> leadRecordsToInsert = (List<Lead>) System.JSON.deserialize(leadRecordDetails, List<Lead>.Class);
        
        if(! leadRecordsToInsert.isEmpty())
        {
        	insert leadRecordsToInsert;
            return 'Lead Records Inserted';
        }
        else
            return 'Lead Records Not Found. Invalid Data.';
    }
     @HttpPut
	Global static String UpdateCaseRecord(string cNumber, string cStatus, string cReason, string cPriority)
    {
    	Case csRecord = [Select id, caseNumber, status, priority, Reason
        						from Case
        								Where caseNumber =: cNumber];
        
        if(csRecord.Id != null)
        {
            csRecord.Status = cStatus;
            csRecord.Reason = cReason;
            csRecord.Priority = cPriority;
            
            Update csRecord;
            
            return 'Case Record Updated Successfully.';
        }
        else
            return 'Case Record Not Found. Invalid Case Number.';
    }
    @HttpPatch()
    Global Static string UpsertHRRecords(string recordID, string hrPhone, string hrCity)
    {
		if(recordID != null && recordID != '')        
        {
            
            List<Hiring_Manager__C> lstHRRecords = new List<Hiring_Manager__C>();
            
            // Update the Hiring Manager Record...
            Hiring_Manager__C hrRecord = [Select id, name, location__C, contact_number__C
                                         				from Hiring_Manager__C
                                         						Where id =: recordID];
            
            if(hrRecord.id != null)
            {
                hrRecord.Location__c = hrCity;
                hrRecord.Contact_Number__c = hrPhone;
                
                // Add the record to collection..
                lstHRRecords.Add(hrRecord);
            }
            
            // Create a New Hiring Manager Record..
            Hiring_Manager__C hr = new Hiring_Manager__C();
            
            	hr.Name = 'Balaram Prasad';
            	hr.Location__c = 'Delhi';
            	hr.Contact_Number__c = '9900887766';
            //	hr.Email__c = 'balaram@gmail.com';
           		 // Add the record to collection..
                lstHRRecords.Add(hr);
            
            if(! lstHRRecords.isEmpty())
            {
                Upsert lstHRRecords;
                return 'Hiring Manager Records Upserted Successfully.';
            }
            else
                return 'Upsert Operation Failed.';
        }
        else
            return 'Please Provide the Record ID.';
    }

}
/*
@RestResource(URLMapping='/AccountContactService/')
global class AccountContactService {
    
    @HttpPost
    global static void createAccountWithContact(String accountName, String contactFirstName, String contactLastName, String contactEmail) {
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        
        try {
            // Step 1: Check if the required parameters are provided
            if (String.isBlank(accountName) || String.isBlank(contactFirstName) || String.isBlank(contactLastName) || String.isBlank(contactEmail)) {
                throw new CustomException('Account Name, Contact First Name, Last Name, and Email are mandatory.');
            }

            // Step 2: Create a savepoint before performing DML operations
            Database.Savepoint sp = Database.setSavepoint();

            // Step 3: Insert Account
            Account newAccount = new Account();
            newAccount.Name = accountName;
            insert newAccount;

            // Step 4: Insert Contact associated with the new Account
            Contact newContact = new Contact();
            newContact.FirstName = contactFirstName;
            newContact.LastName = contactLastName;
            newContact.Email = contactEmail;
            newContact.AccountId = newAccount.Id;

            // Try to insert the contact
            insert newContact;

            // Step 5: Return success response
            response.statusCode = 201;
            response.responseBody = Blob.valueOf('{"message": "Account and Contact created successfully.", "accountId": "' + newAccount.Id + '", "contactId": "' + newContact.Id + '"}');
        } catch (Exception e) {
            // Step 6: If any error occurs, rollback to the savepoint
            Database.rollback(sp);

            // Step 7: Return error response
            response.statusCode = 400;
            response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }

    // Custom exception class to handle user-specific errors
    global class CustomException extends Exception {}
}
@RestResource(URLMapping='/AccountContactService/')
global class Accountsavepointservice {

    @HttpPost
    global static void createAccountWithContact() {
      //  RestRequest request = RestContext.request;
        //RestResponse response = RestContext.response;
       // response.addHeader('Content-Type', 'application/json');

        try {
            // Parse the incoming request body
       //     Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());

            // Extract parameters
            String accountName = (String) params.get('accountName');
            String contactFirstName = (String) params.get('contactFirstName');
            String contactLastName = (String) params.get('contactLastName');
            String contactEmail = (String) params.get('contactEmail');

            // Check for mandatory fields
            if (String.isBlank(accountName) || String.isBlank(contactFirstName) || String.isBlank(contactLastName) || String.isBlank(contactEmail)) {
                throw new CustomException('Account Name, Contact First Name, Last Name, and Email are mandatory.');
            }

            // Create a savepoint
            Database.Savepoint sp = Database.setSavepoint();

            // Insert Account
            Account newAccount = new Account();
            newAccount.Name = accountName;
            insert newAccount;

            // Insert Contact linked to the newly created Account
            Contact newContact = new Contact();
            newContact.FirstName = contactFirstName;
            newContact.LastName = contactLastName;
            newContact.Email = contactEmail;
            newContact.AccountId = newAccount.Id;
            insert newContact;

            // Return success response
            response.statusCode = 201; // HTTP status code for Created
            response.responseBody = Blob.valueOf('{"message": "Account and Contact created successfully.", "accountId": "' + newAccount.Id + '", "contactId": "' + newContact.Id + '"}');

        } catch (CustomException e) {
            response.statusCode = 400; // Bad Request
            response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        } catch (Exception e) {
            // Rollback to the savepoint if any error occurs
            Database.rollback(sp);
            response.statusCode = 500; // Internal Server Error
            response.responseBody = Blob.valueOf('{"error": "An error occurred: ' + e.getMessage() + '"}');
        }
    }

    // Custom exception class for specific error handling
    global class CustomException extends Exception {}
}
*/
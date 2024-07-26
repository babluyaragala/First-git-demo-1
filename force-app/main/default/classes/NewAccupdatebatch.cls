Global class NewAccupdatebatch implements Database.Batchable<SObject>
{
   Global Database.QueryLocator Start(Database.Batchablecontext bcontext)
   {
      String AccountsQuery ='Select Id , Name ,Type ,Annualrevenue ,Rating ,Industry , Ownership , Active__c from Account';
        return Database.getQueryLocator(AccountsQuery);
   }
    Global void execute(Database.Batchablecontext bcontext , List<SObject> batchrecords)
   {
       List<Account>   Accountstoupdate = new List<Account>();
       
       If(! batchrecords.isempty())
       {
           for(SObject  objrec :batchrecords)
           {
               Account Accrecord = (Account) objrec;
               
                 accrecord.AnnualRevenue =75000000;
                 accrecord.Type ='Installation Partner ';
                 accrecord.Ownership ='Private';
                 accrecord.Active__c='yes';
               
               Accountstoupdate.add(accrecord);
           }
          if(! Accountstoupdate.isempty())
          {
               update Accountstoupdate;
          }
       }
   }
    Global void Finish(Database.Batchablecontext bcontext)
   {
       System.debug('Batch Job Id is......: '+ bContext.getJobId());
     
       	AsyncApexJob jobDetails = [Select ID, Status, totalJobItems, jobItemsProcessed,
                                  				numberOfErrors, createdBy.Email
                                  					from AsyncApexJob
                                  						where Id =: bContext.getJobId()];  
       
               Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
       
       String[] toaddress =New String[]{'divejyaragala@gmail.com '};
         sEmail.SetToAddresses(toAddress);
       
        sEmail.SetToAddresses(toAddress);
       
        	sEmail.setSenderDisplayName('DELL Customer Support Center.');
        
        	String emailSubject= 'DELL Weekly Customers Details Update Batch Status Notification - UpdateAccountRecordsBatch ('+ bContext.getJobID()+')';
        	sEmail.SetSubject(emailSubject);
        
        	String emailContent = 'Dear Customer Support, <br/><br/>'+
                					'We are pleased to inform you, that We have Processed DELL Weekly Customers Details Update Batch. <br/><br/>'+
                					'Here are the Batch Job Results....: <br/><br/>'+
                					'Batch Job Id is.......: '+ jobDetails.Id+
                					'<br/>Batch Job Name is.....: UpdateAccountRecordsBatch'+
                					'<br/>Batch Job Status is.....: '+ jobDetails.Status+
                					'<br/>Total Number of Batches......: '+ jobDetails.TotalJobItems+
                					'<br/>Number of Batches Processed....: '+ jobDetails.JobItemsProcessed+
                					'<br/>Number of Batches Failed......: '+ jobDetails.NumberOfErrors+
                					'<br/>Batch Job Owner Email.........: '+ jobDetails.CreatedBy.Email+
                					'<br/><br/> Please contact on the below address, if any queries. <br/><br/>'+
                					'***This is a System Generated Email. Please Do Not Reply. <br/><br/>'+
                					'Thanks & Regards, <br/>Customer Support Center, <br/>DELL Inc.';
        	sEmail.SetHTMLBody(emailContent);
        
        	// Prepare an Attachment (PDF File)...
        		Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        
        			attachment.SetFileName('UpdateAccountRecordsBatch.pdf');
        			attachment.SetContentType('Application/pdf');
        			attachment.body = Blob.topdf(emailContent);
        			
        		List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
        			lstAttachments.Add(attachment);
        
            // Add the Attachment to Email..
            	sEmail.SetFileAttachments(lstAttachments);
        	
        	// Send the Email Alert..
        		Messaging.SendEmailResult[] results = Messaging.SendEmail(new Messaging.SingleEmailMessage[]{sEmail});

   }

}
/*
@RestResource(urlMapping='/PortaluserHelper')
global class Newportaluser {

    @HttpPost
    global static void createNewUser(String firstName, String lastName, String email) {
        // Check if all required parameters are provided
        if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)) {
            RestContext.response.statusCode = System.RestResponse.statusCodeBadrequest;
            RestContext.response.responseBody = Blob.valueOf('Missing required parameters');
            return;
        }

        // Check if the email is in a valid format
        if (!Pattern.matches('^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$', email)) {
            RestContext.response.statusCode = System.RestResponse.statusCodeBadrequest;
            RestContext.response.responseBody = Blob.valueOf('Invalid email format');
            return;
        }

        // Create a new User record
        User newUser = new User(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Username = email, // Setting username same as email for simplicity
            Alias = 'user', // Set an alias for the user
            TimeZoneSidKey = 'America/New_York', // Set timezone
            LocaleSidKey = 'en_US', // Set locale
            EmailEncodingKey = 'UTF-8', // Set email encoding
            ProfileId = '00eXXXXXXXXXXXXXXX', // Replace with the actual Profile Id
            LanguageLocaleKey = 'en_US' // Set language locale
        );

        try {
            // Insert the user
            insert newUser;
            RestContext.response.statusCode = System.RestResponse.statusCodeCreated;
            RestContext.response.responseBody = Blob.valueOf('User created successfully');
            }
           catch (Exception e) 
           {
            RestContext.response.statusCode = System.RestResponse.statusCodeInternalServerError;
            RestContext.response.responseBody = Blob.valueOf('Error creating user: ' + e.getMessage());
           }
    }
}

 */
/*
 @RestResource(urlMapping='/PortaluserHelper/*')
global class Newportaluser {

    @HttpPost
    global static void createNewUser(String firstName, String lastName, String email, String alias) {
        try {
            // Check if any user already exists with the provided email
            List<User> existingUsers = [SELECT Id FROM User WHERE Email = :email LIMIT 1];
            if (!existingUsers.isEmpty()) {
                RestContext.response.responseBody = Blob.valueOf('User with this email already exists');
                return;
            }

            // Check for missing parameters
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email) || String.isBlank(alias)) {
                RestContext.response.responseBody = Blob.valueOf('Missing required parameters');
                return;
            }

            // Create new user
            User newUser = new User(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Username = email,
                Alias = alias,
                TimeZoneSidKey = '(GMT+05:30) India Standard Time (Asia/Kolkata)',
                LocaleSidKey = 'en_IN',
                EmailEncodingKey = 'UTF-8',
                ProfileId = '2F00e5j000000ojBJ',
                LanguageLocaleKey = 'en_US'
            );

            insert newUser;

            RestContext.response.responseBody = Blob.valueOf('User created successfully');
        } catch (Exception e) {
            RestContext.response.responseBody = Blob.valueOf('Error creating user: ' + e.getMessage());
        }
    }
}

*/
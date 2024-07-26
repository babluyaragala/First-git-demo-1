public class Emailapexprogramming 
{
 	Public static void SendBatchJobStatusAlert(AsyncApexJob jobDetails, string jobName, Decimal totalRevenue)
    {
        if(jobDetails.id != Null)
        {
            Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
            
            	String[] toAddress = new String[]{jobDetails.CreatedBy.Email, 'divejyaragala@gmail.com'};
                sEmail.SetToAddresses(toAddress);
            
          //  	List<String> ccAddress = new List<String>{'mamathaaekhila201@gmail.com'};
           //     sEmail.SetCCAddresses(ccAddress);    
                
           // 	String[] bccAddress = new String[]{'kottamasumounika22@gmail.com'};
           //     sEmail.SetBCCAddresses(bccAddress);
            
            	String emailSubject = 'DELL Weekly Customers Total AnnualRevenue Batch Job Alert  - '
                                                                             +jobName+ ' ('+ jobDetails.Id+ ')';
            	sEmail.setSubject(emailSubject);
            
            	sEmail.SetReplyTo('support@dell.com');
            
            	sEmail.setSenderDisplayName('DELL Customer Support Center.');
            
            	String emailContent = 'Dear Customer Support, <br/><br/>'+
                    				'We are pleased to inform you, that we have Processed the DELL Weekly Customers Total Revenue Batch. <br/><br/>'+
                    				'Here are the Batch Job Details.....: <br/><br/>'+
                    				'Batch Job Id is.......: '+ jobDetails.Id+
                    				'<br/>Batch Job Name is......: '+ jobName+
                    				'<br/>Batch Job Status is......: '+ jobDetails.Status+
                    				'<br/>Total Number of Batches......: '+ jobDetails.TotalJobItems+
                    				'<br/>Number of Batches Processed......: '+ jobDetails.JobItemsProcessed+
                    				'<br/>Number of Batches Failed.......: '+ jobDetails.NumberOfErrors+
                    				'<br/>Batch Job Owner Email Address.....: '+ jobDetails.CreatedBy.Email+
                    				'<br/>Total Accounts Revenue is.......: '+ totalRevenue+
                    				'<br/><br/> Please Contact on the below Address, if any queries. <br/><br/>'+
                    				'***This is a System Generated Email. Please Do Not Reply. <br/><br/>'+
                    				'Thanks & Regards, <br/>Customer Support, <br/> DELL Inc.';
          		sEmail.SetHTMLBody(emailContent);  
          		
            	Messaging.SendEmailResult[] results = Messaging.SendEmail(new Messaging.SingleEmailMessage[]{sEmail});
        }
    }
    }
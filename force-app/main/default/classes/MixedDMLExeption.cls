public class MixedDMLExeption 
{
Public static void DoDMLOperations()
    {
        // De-Activate the User (Setup Object)
        	User userInfo = [Select ID, FirstName, LastName, title, UserName, isActive
                            				from User
                            					Where UserName = 'dmahesh@gmail.com'];
        	if(userInfo.id != Null)
            {
                userInfo.IsActive = true;
                userInfo.Username = '	dmahesh12@gmail.com';
                Update userInfo;
                
                // Call the Method...
                CreateHiringManagerRecord();
            }
    }
    
    @future()
    Public static void CreateHiringManagerRecord()
    {
        // Create a New Hiring Manager Record. (Non-Setup Object)
        	Hiring_Manager__c hrRecord = new Hiring_Manager__c();
        
        		hrRecord.Name = 'Test Record';
        		hrRecord.Location__c = 'Vizag';
        		hrRecord.Email_Address__c = 'test@gmail.com';
        	//	hrRecord.Employment_Type__c = 'Permanent';
        	//	hrRecord.Designation__c = 'HR Executive';
        		hrRecord.Current_CTC__c = 1200000;
        		hrRecord.Contact_Number__c = '9900336672';
        
        	Insert hrRecord;
        
        	if(hrRecord.Id != Null)
                System.debug('Hiring Manager Record Inserted Successfully.'+ hrRecord.Id);
    }
}
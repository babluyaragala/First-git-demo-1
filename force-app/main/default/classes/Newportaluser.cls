@RestResource(URLMapping='/PortaluserHelper/*')
global class Newportaluser {

    @HttpPost
    global static void createnewuser(String firstName, String lastName, String email, String alias) {
        try {     
            List<User> existingUsers = [SELECT Id, Email FROM User WHERE Email = :email LIMIT 1];
           
            if (!existingUsers.isEmpty()) 
            {
                throw new UserException('User with this email already exists');
            }
       
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(email)) 
            {
                throw new UserException('Missing required parameters');
            }
       
            User ur = new User();
                ur.FirstName = firstName;
                ur.LastName = lastName;
                ur.Email = email;
                ur.Username = email;
                ur.Alias = alias; 
               ur.TimeZoneSidKey = 'Asia/Kolkata';
                ur.LocaleSidKey = 'en_IN'; 
               ur.EmailEncodingKey = 'UTF-8'; 
               ur.ProfileId = '00e5j000000jkyV'; 
                ur.LanguageLocaleKey = 'en_US'; 
          
            insert ur;
           
            RestContext.response.responseBody = Blob.valueOf('User created successfully'+'User id :'+ ur.id);
            //User created successfullyUser id :0055j00000CFs07AAD
        } catch (UserException e) {
            
            RestContext.response.responseBody = Blob.valueOf(e.getMessage());
        } catch (Exception e) {
       
            RestContext.response.responseBody = Blob.valueOf('An error occurred: ' + e.getMessage());
        }
    }

   @HttpGet
  Global Static String getNewUserDetails() {
    UserDetailsDTO userDetails = new UserDetailsDTO();
 
    User existingUser = [SELECT Id, FirstName, LastName, Email, Username, 
                         ContactId, IsActive, LocaleSidKey, LanguageLocaleKey
                         FROM User 
                         WHERE Id = :'0055j00000CFs07AAD'
                         LIMIT 1];
    
    userDetails.UserId = existingUser.Id;
    userDetails.EmailAddress = existingUser.Email;
    userDetails.Username = existingUser.Username;
    userDetails.FirstName = existingUser.FirstName;
    userDetails.LastName = existingUser.LastName;
    userDetails.UserLocale = existingUser.LocaleSidKey;
    userDetails.UserLanguage = existingUser.LanguageLocaleKey;
    userDetails.ContactId = existingUser.ContactId;
    userDetails.IsActive = existingUser.IsActive;
    
    String jsonString = JSON.serialize(userDetails);
    
    return jsonString;
}


}
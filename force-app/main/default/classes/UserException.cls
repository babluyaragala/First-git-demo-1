public class UserException extends Exception 
{

}



























/*
@RestResource(URLMapping='/AccountContactService/')
global class AccountService {

    @HttpPost
    global static void createAccountWithContact(String jsonBody) {
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');

        try {
            // Deserialize JSON into the DTO
            AccountContactDTO dto = (AccountContactDTO) JSON.deserialize(jsonBody, AccountContactDTO.class);

            // Validate the DTO data
            dto.validate();

            // Create Account
            Account newAccount = new Account(Name = dto.accountName);
            insert newAccount;

            // Create Contact linked to the new Account
            Contact newContact = new Contact(
                FirstName = dto.contactFirstName,
                LastName = dto.contactLastName,
                Email = dto.contactEmail,
                AccountId = newAccount.Id
            );
            insert newContact;

            // Respond with success message
            response.statusCode = 201; // HTTP status code for Created
            response.responseBody = Blob.valueOf('{"message": "Account and Contact created successfully.", "accountId": "' + newAccount.Id + '", "contactId": "' + newContact.Id + '"}');
        } catch (ValidationException ve) {
            // Handle custom validation exceptions
            response.statusCode = 400; // Bad Request
            response.responseBody = Blob.valueOf('{"error": "' + ve.getMessage() + '"}');
        } catch (Exception e) {
            // Handle other exceptions
            response.statusCode = 500; // Internal Server Error
            response.responseBody = Blob.valueOf('{"error": "An unexpected error occurred: ' + e.getMessage() + '"}');
        }
    }
}
*/
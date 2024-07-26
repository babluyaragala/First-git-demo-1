@RestResource(URLMapping='/UserwebServiceHelper/*')
global with sharing class User_WebService {
    @HttpPatch
    global static void Users() {
        String requestBody = RestContext.request.requestBody.toString();
        system.debug('request body '+requestBody);
        Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
        String fname = (String) requestBodyMap.get('firstname');
        System.debug( 'firstname'+ fname);
        String lname = (String) requestBodyMap.get('lastname');
        System.debug( 'lastname'+ lname);
        String email = (String) requestBodyMap.get('email');
        System.debug( 'email'+ email);
        String alias = (String) requestBodyMap.get('alias');
        System.debug( 'alias'+ alias);
        try { 
            if (String.isBlank(email) || String.isBlank(lname)){
            throw new UserException('LastName and Email are mandatory fields.');
        }
            UserserviceInterface userService = (UserserviceInterface) Application.service.newInstance(UserserviceInterface.class);
            userService.usernewrecords(fname, lname, email ,alias);
        } catch (UserException e) {
            RestContext.response.responseBody = Blob.valueOf('Error: ' + e.getMessage());
        } catch (Exception e) {
            RestContext.response.responseBody = Blob.valueOf('An unexpected error occurred: ' + e.getMessage());
        }
    }
}
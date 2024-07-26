@RestResource(URLMapping='/LeadwebServiceHelper/*')
global with sharing class Lead_Web_Service {
    @HttpPatch
    global static void Leads() {
        String requestBody = RestContext.request.requestBody.toString();
        system.debug('request body '+requestBody);
        Map<String, Object> requestBodyMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        
        String fname = (String) requestBodyMap.get('firstname');
        System.debug( 'firstname'+ fname);
        String lname = (String) requestBodyMap.get('lastname');
        System.debug( 'lastname'+ lname);
        String email = (String) requestBodyMap.get('email');
        System.debug( 'email'+ email);
        try {    
       Leads.validateLead(email, lname);
            LeadServiceInterface leadService = (LeadServiceInterface) Application.service.newInstance(LeadServiceInterface.class);
            leadService.upsertLead(fname, lname, email);
        } catch (Lead_Exception e) {
            RestContext.response.responseBody = Blob.valueOf('Error: ' + e.getMessage());
        } catch (Exception e) {
            RestContext.response.responseBody = Blob.valueOf('An unexpected error occurred: ' + e.getMessage());
        }
    }
}
@RestResource(urlMapping='/accountcompanyemployeeservice/*')
global class AccountCompanyInfoService 
{

    @HttpGet
    global static AccountcompanyinfoDTO getCompanyInfo() 
    {
        
          RestRequest req = RestContext.request;
        
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        
        
         if (String.isBlank(accountId)) 
         {
            
            return null;
        }

     
        List<Account>  accList = [ SELECT Id, Name,
                   (SELECT Id, LastName, Email, Phone FROM Contacts)
                                           FROM Account
                                              WHERE Id = :accountId];  
        if (accList == null) 
        {  
            return null;
        }
        
          Account accinfo = accList[0];
        
        List<ContactEmployeeInfoDTO> employees = new List<ContactEmployeeInfoDTO>();

        AccountcompanyinfoDTO companyInfo = new AccountcompanyinfoDTO();
        
        companyInfo.accountId = accinfo.Id;
        companyInfo.accountName = accinfo.Name;    
        companyInfo.employees = employees;
        
        for (Contact contact : accinfo.Contacts) 
        {
            ContactEmployeeInfoDTO con = new ContactEmployeeInfoDTO();
            con.contactId = contact.Id;
            con.contactName = contact.LastName;
            con.email = contact.Email;
            con.phone = contact.Phone;                 
            employees.add(con);
        }
        return companyInfo;
    }

    global class AccountcompanyinfoDTO 
    {
        public String accountId;
        public String accountName;
        public List<ContactEmployeeInfoDTO> employees;    
    }
    
    global class ContactEmployeeInfoDTO 
    {
        public String contactId;
        public String contactName;
        public String email;
        public String phone;

    }
}
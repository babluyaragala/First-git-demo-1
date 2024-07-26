public class Contact_Factory {
  Public List<Contact> Insertcontact(String Fname ,String Lname , String email){
         List<Contact> conrecords = new List<Contact>();
              Contact  con = new Contact();
                       con.FirstName = fname;
                       con.LastName  = lname;
                       con.Email     = email;
                       conrecords.add(con);      
              return conrecords;
  }
}
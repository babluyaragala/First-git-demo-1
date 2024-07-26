public class User_Factory {
  Public  List<User> Insertuser(String Fname,String Lname,String email,String alias){
          List<User> Insertusers = new List<User>();
           User ur = new User();
                ur.FirstName = Fname;
                ur.LastName = Lname;
                ur.Email = email;
                ur.Username = email;
                ur.Alias = alias; 
                ur.TimeZoneSidKey = 'Asia/Kolkata';
                ur.LocaleSidKey = 'en_IN'; 
                ur.EmailEncodingKey = 'UTF-8'; 
                ur.ProfileId = '00e5j000000jkyV'; 
                ur.LanguageLocaleKey = 'en_US';
          Insertusers.add(ur);          
          return Insertusers;
      }
}
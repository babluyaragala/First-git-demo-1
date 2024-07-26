public class UserserviceImp implements UserserviceInterface{
    public void usernewrecords(String fname, String lname, String email ,String alias){
        User_Service.usercreation(lname, fname, email, alias);
    }
}
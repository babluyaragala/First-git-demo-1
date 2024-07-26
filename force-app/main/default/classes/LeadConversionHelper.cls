public class LeadConversionHelper {
    public static String getConvertedStatus() {
        List<LeadStatus> convertedStatuses = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
                if (!convertedStatuses.isEmpty()){
            return convertedStatuses[0].MasterLabel;
        } else{
            return null; 
        }
    }
}
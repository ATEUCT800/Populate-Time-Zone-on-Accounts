public with sharing class AccountTrH {
    public static void afterInsert(List<Account> newRecords) {
        Set<Id> newInsAccIds = new Set<Id>();
        List<String> states = new List<String> {'TX','AK','TN','SD','OR','ND','NE','MI','KY','KS','IN','ID','FL'};
        for(Account accItem : newRecords){
           if(accItem.ShippingState != null) {
            for (String s : states) {
            if(accItem.ShippingState.contains(s)){
            newInsAccIds.add(accItem.Id);  
     }
    }   
 }    
            if(!newInsAccIds.isEmpty()){
    TimeZoneReceiver.populateAccountTimeZoneField(newInsAccIds);
    }
  }
}
    public static void afterUpdate(List<Account> newRecords, Map<Id, Account> oldAccountMap) {
        Set<Id> newUpdAccIds = new Set<Id>(); 
        List<String> states = new List<String> {'TX','AK','TN','SD','OR','ND','NE','MI','KY','KS','IN','ID','FL'};
        for(Account accItem : newRecords){
            if(accItem.ShippingState != null && accItem.TimeZone__c == null/* (accItem.ShippingStreet != oldAccountMap.get(accItem.Id).ShippingStreet ||
                    accItem.ShippingCity != oldAccountMap.get(accItem.Id).ShippingCity ||
                    accItem.ShippingState != oldAccountMap.get(accItem.Id).ShippingState )*/) {                        
                        for (String s : states) {
       					if(accItem.ShippingState.contains(s)){
              		newUpdAccIds.add(accItem.Id);  
                }
            }           
        }
        if(!newUpdAccIds.isEmpty()){
            TimeZoneReceiver.populateAccountTimeZoneField(newUpdAccIds);
        }
    }		
  }
}
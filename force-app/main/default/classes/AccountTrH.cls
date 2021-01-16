public with sharing class AccountTrH {
    public static void afterInsert(List<Account> newRecords) {
        Set<Id> newAccIds = new Set<Id>();
        for(Account accItem : newRecords){
            newAccIds.add(accItem.Id);
        }
        TimeZoneReceiver.populateAccountTimeZoneField(newAccIds);
    }
}

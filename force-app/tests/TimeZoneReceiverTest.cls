@isTest
public with sharing class TimeZoneReceiverTest {

    @isTest
    static void timezoneReceiverOneAccTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', BillingCity='Beverly Hills', BillingState='CA');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT BillingCity, BillingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('PST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverBadAddressTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', BillingStreet='141141151 Muhhamed Drakula', BillingCity='ThisCityWillNeverExistForSure', BillingState='CA');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT BillingStreet, BillingCity, BillingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('City Not Found', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverBulkTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc1 = new Account(Name='Test Account Name 1', Rating='Hot', BillingCity='ThisCityWillNeverExistForSure', BillingState='CA');
        Account testAcc2 = new Account(Name='Test Account Name 2', Rating='Hot', BillingCity='Beverly Hills', BillingState='CA');
        List<Account> accList = new List<Account>{testAcc1, testAcc2};
        Test.startTest();
        Database.SaveResult[] resultList = Database.insert(accList, false);
        Test.stopTest();
        List<Account> accListQuery = [SELECT BillingCity, BillingState, TimeZone__c FROM Account WHERE Id IN :accList];
        for(Database.SaveResult result : resultList){
            System.assert(result.isSuccess(), 'Error while inserting test account');
        }
        System.assertEquals('City Not Found', accListQuery[0].TimeZone__c, 'Recieved Timezone is different from expected');
        System.assertEquals('PST', accListQuery[1].TimeZone__c, 'Recieved Timezone is different from expected');
        
    }
}

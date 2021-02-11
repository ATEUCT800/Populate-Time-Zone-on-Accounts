@isTest
public with sharing class TimeZoneReceiverTest {

    @isTest
    static void timezoneReceiverOneAccTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', ShippingCity='Austin', ShippingState='TX');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverBadAddressTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', ShippingStreet='141141151 Muhhamed Drakula', ShippingCity='ThisCityWillNeverExistForSure', ShippingState='TX');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT ShippingStreet, ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('City Not Found', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverBulkTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc1 = new Account(Name='Test Account Name 1', Rating='Hot', ShippingCity='ThisCityWillNeverExistForSure', ShippingState='TX');
        Account testAcc2 = new Account(Name='Test Account Name 2', Rating='Hot', ShippingCity='Austin', ShippingState='TX');
        List<Account> accList = new List<Account>{testAcc1, testAcc2};
        Test.startTest();
        Database.SaveResult[] resultList = Database.insert(accList, false);
        Test.stopTest();
        List<Account> accListQuery = [SELECT ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id IN :accList];
        for(Database.SaveResult result : resultList){
            System.assert(result.isSuccess(), 'Error while inserting test account');
        }
        System.assertEquals('City Not Found', accListQuery[0].TimeZone__c, 'Recieved Timezone is different from expected');
        System.assertEquals('CST', accListQuery[1].TimeZone__c, 'Recieved Timezone is different from expected');
    }
    @isTest
    static void timezoneReceiverOneAccUpdateWithChangeTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', ShippingCity='Austin', ShippingState='TX');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
        acc.ShippingCity = 'Houston';
        acc.ShippingState = 'TX';
        result = Database.update(acc, false);
        acc = [SELECT ShippingStreet, ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :acc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverOneAccUpdateWithoutChangeTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', ShippingCity='Austin', ShippingState='TX');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
        result = Database.update(acc, false);
        acc = [SELECT ShippingStreet, ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :acc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }

    @isTest
    static void timezoneReceiverBadAddressWithUpdateTest() {
        Test.setMock(HttpCalloutMock.class, new TimeZoneReceiverMock());
        Account testAcc = new Account(Name='Test Account Name', Rating='Hot', ShippingStreet='141141151 Muhhamed Drakula', ShippingCity='ThisCityWillNeverExistForSure', ShippingState='TX');
        Test.startTest();
        Database.SaveResult result = Database.insert(testAcc, false);
        Test.stopTest();
        Account acc = [SELECT ShippingStreet, ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :testAcc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('City Not Found', acc.TimeZone__c, 'Recieved Timezone is different from expected');
        acc.ShippingCity = 'Anchorage';
        acc.ShippingState = 'TX';
        acc.TimeZone__c = 'CST';
        result = Database.update(acc, false);
        acc = [SELECT ShippingStreet, ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id = :acc.Id];
        System.assert(result.isSuccess(), 'Error while inserting test account');
        System.assertEquals('CST', acc.TimeZone__c, 'Recieved Timezone is different from expected');
    }
}

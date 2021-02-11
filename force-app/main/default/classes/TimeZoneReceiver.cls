public with sharing class TimeZoneReceiver {
    
    @future(callout = true)
    public static void populateAccountTimeZoneField(Set<Id> Ids) {
        String timezone = '';
        List<Account> accList = [SELECT ShippingCity, ShippingState, TimeZone__c FROM Account WHERE Id IN :Ids];
        for(Account accItem : accList){
            try{
                timezone = getTimeZone(accItem.ShippingCity, accItem.ShippingState);
                accItem.TimeZone__c = timezone;
            } catch (CalloutException ce){
                accItem.TimeZone__c = 'City Not Found';
            }   
        }
        update accList;
    }

    private static String getTimeZone(String city, String state) {
        String cityWithoutSpaces = city.replace(' ', '+');
        String stateWithoutSpaces = state.replace(' ', '+');
        String endpoint = 'https://vip.timezonedb.com/v2.1/get-time-zone?key=K1J4F2W6Z05T&format=json&by=city&city=' + cityWithoutSpaces + '&region=' + stateWithoutSpaces + '&country=US';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        System.debug('endpoint = ' + endpoint);
        HttpResponse res = h.send(req);
        Map<String, Object> locationMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        System.debug('locationMap = ' + locationMap);
        if((String)locationMap.get('status') == 'FAILED'){
            System.debug('locationMap = ' + locationMap);
            throw new CalloutException('We couldn\'t find such address!');
        }
        List<Object> locationList = (List<Object>) locationMap.get('zones');
        locationMap = (Map<String, Object>)locationList[0];
        String timezone = (String) locationMap.get('abbreviation');
        return timezone;
    }
}

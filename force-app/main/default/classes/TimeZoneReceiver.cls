public with sharing class TimeZoneReceiver {
    
    private static List<Double> getGeo(String address, String city, String state) {
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address=' +address+ ',+' +city+ ',+' +state+ '&key=AIzaSyBLSu2altBkaBeChLWVI5v9BB8FIqTOOjQ';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = h.send(req);  
        Map<String, Object> locationMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if((String)locationMap.get('status') == 'ZERO_RESULTS'){
            throw new CalloutException('We couldn\'t find such address!');
        }
        List<Object> locationList = (List<Object>) locationMap.get('results');
        for(Object objectItem : locationList) {
            Map<String, Object> objMap = (Map<String, Object>)objectItem;
            if(objMap.containsKey('geometry')){
                locationMap = (Map<String, Object>) objMap.get('geometry');
            }
        }
        locationMap = (Map<String, Object>) locationMap.get('location');
        Double latitude = (Double) locationMap.get('lat');
        Double longitude = (Double) locationMap.get('lng');
        return new List<Double>{latitude, longitude};
    }

    @future(callout = true)
    public static void populateAccountTimeZoneField(Set<Id> Ids) {
        String address = '';
        String city = '';
        String state = '';
        List<Double> geocode = new List<Double>();
        Double latitude;
        Double longitude;
        String timezone = '';
        List<Account> accList = [SELECT BillingStreet, BillingCity, BillingState, TimeZone__c FROM Account WHERE Id IN :Ids];
        for(Account accItem : accList){
            address = accItem.BillingStreet.replace(' ', '+');
            city = accItem.BillingCity.replace(' ', '+');
            state = accItem.BillingState.replace(' ', '+');
            try{
                geocode = getGeo(address, city, state);
                latitude = geocode[0];
                longitude = geocode[1];
                timezone = getTimeZone(latitude, longitude);
                accItem.TimeZone__c = timezone;
            } catch (CalloutException ce){
                accItem.TimeZone__c = 'Address Not Found';
            }   
        }
        update accList;
    }

    
    private static String getTimeZone(Double latitude, Double longitude) {
        String endpoint = 'https://maps.googleapis.com/maps/api/timezone/json?location=' + latitude + ',' + longitude + '&timestamp=1458000000&key=AIzaSyBLSu2altBkaBeChLWVI5v9BB8FIqTOOjQ';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        Map<String, Object> locationMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        String timezone = (String) locationMap.get('timeZoneName');
        return timezone;
    }
}

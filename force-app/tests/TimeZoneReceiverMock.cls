@isTest
global class TimeZoneReceiverMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().contains('ThisCityWillNeverExistForSure')){
            response.setBody('{ "results" : [], "status" : "ZERO_RESULTS" }');
        }else if (request.getEndpoint().contains('maps.googleapis.com/maps/api/geocode')){
            response.setBody('{ "results" : [ { "address_components" : [ { "long_name" : "Austin", "short_name" : "Austin", "types" : [ "locality", "political" ] }, { "long_name" : "Travis County", "short_name" : "Travis County", "types" : [ "administrative_area_level_2", "political" ] }, { "long_name" : "Texas", "short_name" : "TX", "types" : [ "administrative_area_level_1", "political" ] }, { "long_name" : "United States", "short_name" : "US", "types" : [ "country", "political" ] } ], "formatted_address" : "Austin, TX, USA", "geometry" : { "bounds" : { "northeast" : { "lat" : 30.5168629, "lng" : -97.56841989999999 }, "southwest" : { "lat" : 30.0986589, "lng" : -97.93838289999999 } }, "location" : { "lat" : 30.267153, "lng" : -97.74306079999999 }, "location_type" : "APPROXIMATE", "viewport" : { "northeast" : { "lat" : 30.5168629, "lng" : -97.56841989999999 }, "southwest" : { "lat" : 30.0986589, "lng" : -97.93838289999999 } } }, "place_id" : "ChIJLwPMoJm1RIYRetVp1EtGm10", "types" : [ "locality", "political" ] } ], "status" : "OK" }');
        } else if(request.getEndpoint().contains('maps.googleapis.com/maps/api/timezone')) {
            response.setBody('{ "dstOffset" : 3600, "rawOffset" : -21600, "status" : "OK", "timeZoneId" : "America/Chicago", "timeZoneName" : "Central Daylight Time" }');
        }
        response.setStatusCode(200);
        return response;
    }
}

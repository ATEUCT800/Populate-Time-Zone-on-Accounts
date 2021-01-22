@isTest
global class TimeZoneReceiverMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().contains('ThisCityWillNeverExistForSure')){
            response.setBody('{ "results" : [], "status" : "ZERO_RESULTS" }');
        }else if (request.getEndpoint().contains('maps.googleapis.com/maps/api/geocode')){
            response.setBody('{ "results" : [ { "address_components" : [ { "long_name" : "14111", "short_name" : "14111", "types" : [ "street_number" ] }, { "long_name" : "Mulholland Drive", "short_name" : "Mulholland Dr", "types" : [ "route" ] }, { "long_name" : "Sherman Oaks", "short_name" : "Sherman Oaks", "types" : [ "neighborhood", "political" ] }, { "long_name" : "Beverly Hills", "short_name" : "Beverly Hills", "types" : [ "locality", "political" ] }, { "long_name" : "Los Angeles County", "short_name" : "Los Angeles County", "types" : [ "administrative_area_level_2", "political" ] }, { "long_name" : "California", "short_name" : "CA", "types" : [ "administrative_area_level_1", "political" ] }, { "long_name" : "United States", "short_name" : "US", "types" : [ "country", "political" ] }, { "long_name" : "90210", "short_name" : "90210", "types" : [ "postal_code" ] } ], "formatted_address" : "14111 Mulholland Dr, Beverly Hills, CA 90210, USA", "geometry" : { "location" : { "lat" : 34.1321681, "lng" : -118.4393789 }, "location_type" : "ROOFTOP", "viewport" : { "northeast" : { "lat" : 34.1335170802915, "lng" : -118.4380299197085 }, "southwest" : { "lat" : 34.13081911970851, "lng" : -118.4407278802915 } } }, "place_id" : "ChIJ-xBnq4K9woARiCPBBpK9gZs", "plus_code" : { "compound_code" : "4HJ6+V6 Beverly Hills, CA, USA", "global_code" : "85634HJ6+V6" }, "types" : [ "street_address" ] } ], "status" : "OK" }');
        } else if(request.getEndpoint().contains('maps.googleapis.com/maps/api/timezone')) {
            response.setBody('{ "dstOffset" : 3600, "rawOffset" : -28800, "status" : "OK", "timeZoneId" : "America/Los_Angeles", "timeZoneName" : "Pacific Daylight Time" }');
        }
        response.setStatusCode(200);
        return response;
    }
}

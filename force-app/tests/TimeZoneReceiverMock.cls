@isTest
global class TimeZoneReceiverMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().contains('ThisCityWillNeverExistForSure')){
            response.setBody('{"status":"FAILED","message":"Record not found.","totalPage":1,"currentPage":1,"zones":[]}');
        }else if (request.getEndpoint().contains('vip.timezonedb.com')){
            response.setBody('{"status":"OK","message":"","totalPage":1,"currentPage":1,"zones":[{"countryCode":"US","countryName":"United States","regionName":"California","cityName":"Los Angeles","zoneName":"America\\/Los_Angeles","abbreviation":"PST","gmtOffset":-28800,"dst":"0","zoneStart":1604221200,"timestamp":1612249538,"formatted":"2021-02-02 07:05:38","zoneEnd":1615716000,"nextAbbreviation":"PDT"}]}');
        }
        response.setStatusCode(200);
        return response;
    }
}

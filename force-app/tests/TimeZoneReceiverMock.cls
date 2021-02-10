@isTest
global class TimeZoneReceiverMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(request.getEndpoint().contains('ThisCityWillNeverExistForSure')){
            response.setBody('{"status":"FAILED","message":"Record not found.","totalPage":1,"currentPage":1,"zones":[]}');
        }else if (request.getEndpoint().contains('vip.timezonedb.com')){
            response.setBody('{"status":"OK","message":"","totalPage":1,"currentPage":1,"zones":[{"countryCode":"US","countryName":"United States","regionName":"Texas","cityName":"Austin","zoneName":"America\\/Chicago","abbreviation":"CST","gmtOffset":-21600,"dst":"0","zoneStart":1604214000,"timestamp":1612934306,"formatted":"2021-02-10 05:18:26","zoneEnd":1615708800,"nextAbbreviation":"CDT"}]}');
        }
        response.setStatusCode(200);
        return response;
    }
}

public with sharing class ClassGoogleGeoLocationCallout
{
@future (callout=true)  
    public static void getlocationlatlong(string address)
    {
        // make post request
        
        string latlong='';
        string flag='no';
        double lat = null;
        double lon = null;
      //  address = EncodingUtil.urlEncode(address, 'UTF-8');
          PageReference p = new PageReference('https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');                       
           String body = p.getURL();
            body= body.subStringAfter('?');
            HttpRequest objrequest = new HttpRequest();
            objrequest.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json');
            objrequest.setMethod('GET');
            objrequest.setCompressed(false);            
            objrequest.setHeader('Encoding','iso-8859-1');
            objrequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            objrequest.setTimeout(120000);//max timeout
            if( body != null )
             { //should be null if a GET
                 objrequest.setBody(body);
                 objrequest.setHeader('Content-length',string.valueOf(body.length()));
             }
            HttpResponse objresponse = new http().send(objrequest);
            if(objresponse.getStatusCode() == 200)
            {
                JSONParser parser = JSON.createParser(objresponse.getBody());
                JSONParser parser2 =JSON.createParser(objresponse.getBody());
                while (parser.nextToken() != null) 
                {
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == 'status'))
                    {
                         String txt = parser.getText();
                         if(txt=='OK')
                         {
                              flag='yes';               
                         }
                    }
                }
                if(flag=='yes')
                {
                     while (parser2.nextToken() != null) 
                        {
                            if ((parser2.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser2.getText() == 'location'))
                            {
                               parser2.nextToken(); // object start
                               while (parser2.nextToken() != JSONToken.END_OBJECT)
                               {
                                   String txt = parser2.getText();
                                   parser2.nextToken();
                                   if (txt == 'lat')
                                       lat = parser2.getDoubleValue();
                                   else if (txt == 'lng')
                                       lon = parser2.getDoubleValue();
                              } 
                            }
                        }
                    latlong=((string.valueof(lat))+','+(string.valueof(lon)));
                   // t1.latitude__c=latlong;
                   // update t1;
                }
                else
                {
                  ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error');
                  ApexPages.addMessage(errorMsg);

                }
               
            }
            else
            {
               ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'dummyError');
               ApexPages.addMessage(errorMsg);
            }
      
           
         // return latlong;   
            
        }
       
        
       
    
}
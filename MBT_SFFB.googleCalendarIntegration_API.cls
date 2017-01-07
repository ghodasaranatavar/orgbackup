/**

@author Innodel Technologies PVT LTD
@date 26 th OCT 2016
@description Authentication code , Autherisation
*/
global class googleCalendarIntegration_API {
    public static String calendar_api_client_id ='624701440392-94a1q855vfi0i1dvv2idji9luq7s67ik.apps.googleusercontent.com'; 
    public static String calendar_api_client_secret ='z33pDNcb7PrOdV-_kHRlq_-7';
    public static String calendar_api_scope ='https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks https://www.google.com/m8/feeds/'; 
    public static String calendar_api_callback_page='https://c.ap2.visual.force.com/apex/google_callback_oauth_vf';    
    public static String calendar_api_state='hghg54DFVkjkSKSas4s53';
    public static String calendar_api_oauthlink ='https://accounts.google.com/o/oauth2/auth';
    public static String calendar_api_oauthtokenlink ='https://accounts.google.com/o/oauth2/token';
    public static String calendar_api_code='';
    public static String calendar_api_calendarlink ='https://www.googleapis.com/calendar/v3/users/me/calendarList';
    public static String calendar_api_accesstoken='';
    public static String calendar_api_refreshtoken='';
    public static String calendar_api_primarycalendar ='https://www.googleapis.com/calendar/v3/users/me/calendarList/primary';
    
    public static String calendar_api_calendar_by_id ='https://www.googleapis.com/calendar/v3/calendars/';
    
    public googleCalendarIntegration_API()
    {
        // Default constructor        
    }
     /**
        @date 26 th OCT 2016
        @description Method is to get authentication screen and user should insert Username password for oauth 2.0.        
    */
    public static PageReference Request_Google_oAuth()
    {
        PageReference p = new PageReference(calendar_api_oauthlink);
        p.getParameters().put('response_type','code');
        p.getParameters().put('client_id',calendar_api_client_id);
        p.getParameters().put('redirect_uri',calendar_api_callback_page);
        p.getParameters().put('approval_prompt','force');
        p.getParameters().put('scope',calendar_api_scope); 
        p.getParameters().put('state',calendar_api_state);
        p.getParameters().put('access_type','offline');
        return p;
    }
     /**
        @date 26 th OCT 2016
        @description Method is to get authentication screen and user should insert Username password for oauth 2.0.        
    */
    public static String Request_Google_token()
    {
        if((ApexPages.currentPage().getParameters().get('code')!='')&&((ApexPages.currentPage().getParameters().get('state')==calendar_api_state)))
        {
            calendar_api_code=ApexPages.currentPage().getParameters().get('code');
            PageReference p = new PageReference(calendar_api_oauthtokenlink);
            p.getParameters().put('grant_type','authorization_code');
            p.getParameters().put('client_id',calendar_api_client_id);
            p.getParameters().put('redirect_uri',calendar_api_callback_page);
            p.getParameters().put('client_secret',calendar_api_client_secret);          
            p.getParameters().put('code',calendar_api_code);
            String body = p.getURL();
            body = body.subStringAfter('?');
            HttpRequest objrequest = new HttpRequest();
            objrequest.setEndpoint(calendar_api_oauthtokenlink);
            objrequest.setMethod('POST');
            objrequest.setCompressed(false);
            objrequest.setHeader('User-Agent','Calendar');
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
                calendar_api_accesstoken=parseJson(objresponse.getBody(),'access_token');
                calendar_api_refreshtoken=parseJson(objresponse.getBody(),'refresh_token');
                return calendar_api_accesstoken;
            }
            else
            {
                //error
                return '';
            }
        }
        return '';
        
    }
    /**
        @date 26 th OCT 2016
        @description 
    */
    public static String parseJson(String Jsonstring, String Fieldname)
    {       
         jsonParser parser = json.createParser(Jsonstring);
         while (parser.nextToken() != null )
         {
             if ( parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() != null && parser.getText() == Fieldname )
             {
                 parser.nextToken();
                 return parser.getText(); 
             }
         }
         return ''; 
    }
    /**
        @date 26 th OCT 2016
        @description 
    */
    public static String Request_Google_Calendarlist(String accesstoken)
    {
       
        HttpRequest objrequest = new HttpRequest();
        objrequest.setEndpoint(calendar_api_calendarlink+'?key='+accesstoken);
        objrequest.setMethod('GET'); 
        objrequest.setHeader('authorization','Bearer '+accesstoken);                  
        objrequest.setHeader('Content-Type', 'application/json; charset=UTF-8');        
        objrequest.setTimeout(120000);//max timeout           
        HttpResponse objresponse = new http().send(objrequest);
       if(objresponse.getStatusCode() == 200)
        {
            return (objresponse.getBody());
        }
        else
        {   //error
            return 'error';
        }
        return '';
        
    }
    /**
        @date 26 th OCT 2016
        @description 
    */
     public static String Request_Google_Primary_Calendar(String accesstoken)
    {
        HttpRequest objrequest = new HttpRequest();
        objrequest.setEndpoint(calendar_api_primarycalendar+'?'+accesstoken);
        objrequest.setMethod('GET');           
        objrequest.setHeader('authorization','Bearer '+accesstoken);
        objrequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
        objrequest.setTimeout(120000);//max timeout
        HttpResponse objresponse = new http().send(objrequest);        
        if(objresponse.getStatusCode() == 200)
        {
            return parseJson(objresponse.getBody(),'id');
            
        }
        else
        {   //error
            return 'error';
        }
        return '';
    }
    public static String Request_Google_Calendar_by_ID(String calendar_id, String accesstoken)
    {
        HttpRequest objrequest = new HttpRequest();
        objrequest.setEndpoint(calendar_api_calendar_by_id+calendar_id+'/events?key='+accesstoken);
        objrequest.setMethod('GET');           
        objrequest.setHeader('authorization','Bearer '+accesstoken);
        objrequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
        objrequest.setTimeout(120000);//max timeout
        HttpResponse objresponse = new http().send(objrequest);        
        if(objresponse.getStatusCode() == 200)
        {
            return (objresponse.getBody());
        }
        else
        {   //error
             //return (objresponse.getBody());
        }
        return '';
    }
}
global class googleCalendar_API {
Static string cr = '\r\n';
public static final string CALENDER_LIST_URL='https://www.googleapis.com/calendar/v3/users/me/calendarList';
public static final string CALENDER_EVENT_URL='https://www.googleapis.com/calendar/v3/calendars/';
static map<id,User> userMap = new map<id,User>([select id, name, google_Email__c, Google_Access_Token__c,Google_Refresh_Token__c from User where isActive=true]); 
//client id from app creation
public static String GOOGLE_API_CLIENT_ID =
'624701440392-94a1q855vfi0i1dvv2idji9luq7s67ik.apps.googleusercontent.com';
 //client secret from app creation
 public static String GOOGLE_API_CLIENT_SECRET =
'z33pDNcb7PrOdV-_kHRlq_-7';
 //necessary access scope from calendar documentation
 public static String GOOGLE_CALENDAR_SCOPE =
'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/tasks';
 //our authorization page – make sure to change to yours!
 public static String SF_AUTH_PAGE =
 'https://c.ap2.visual.force.com/apex/authsub';
// our request method, takes in our authorized redirect URI //(recall from setting up the Google App)
public static User obtainAccessToken(User u, String code,String redirectURL)
{
//any url you want, we are using this as a shortcut to //URL encode our parameters
 PageReference p = new PageReference('http://www.replace.com');
 p.getParameters().put('client_id',googleCalendar_API.GOOGLE_API_CLIENT_ID);
 p.getParameters().put('client_secret',googleCalendar_API.GOOGLE_API_CLIENT_SECRET);
 //no scope this time
 p.getParameters().put('scope','');
 p.getParameters().put('redirect_uri',redirectURL);

//declaring we want an access token
 p.getParameters().put('grant_type','authorization_code');
 //adding in our valid request token
 p.getParameters().put('code',code);
 //retrieve the constructed, URL encoded url
 String body = p.getURL();
 //grab only the parameters
 body = body.subStringAfter('?');
 //use our callGoogle method to POST our body
 httpResponse googleAuth = callGoogle('https://accounts.google.com/o/oauth2/token','POST',body);
 //handle success
 if ( googleAuth.getStatusCode() == 200 )
 {
 //updates user with tokens
 u = parseGoogleAuth(googleAuth.getBody(), u);
 }
 //handle failure
 else u.Google_Access_Token__c ='error';
 return u;
 }
 public static string getcalenderidlist(string tokenparam)
 {
     Http h = new Http(); 
     HttpRequest req = new HttpRequest();
               req.setEndpoint(CALENDER_LIST_URL);
               req.setHeader('authorization','Bearer '+tokenparam);
               req.setHeader('Content-Type','application/http');
               req.setMethod('GET');               
               HttpResponse res = h.send(req);                        
               system.debug('body'+res.getbody());
               return res.getbody();
 }
  public static Map<String, Object> parsecalenderid(string jsonstring) 
    {
        // returns primary account
        Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonstring);
        List<Object> items = (List<Object>)root.get('items');
        Map<String, Object> primary =  new  Map<String, Object>();
        for (Object item : items) 
        {
            Map<String, Object> i = (Map<String, Object>)item;
            if(i.get('primary')==true)
            {
               primary =i;
            }
        }
        return primary;
    }  
  //parses response from Google authentication
//into the user fields
 public static User parseGoogleAuth(String body, User u)
 {
 //the response is JSON, use a parser
 jsonParser parser = json.createParser(body);
 while ( parser.nextToken() != null )
 {
     if ( parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() != null && parser.getText() == 'access_token' )
     {
     parser.nextToken();
     //assign access token
     u.Google_Access_Token__c = parser.getText();
     } 
     else if ( parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() != null && parser.getText() == 'refresh_token' )
     {
         parser.nextToken();
         //assign refresh token
         u.Google_Refresh_Token__c = parser.getText();
     }
 }
 return u;
 }
 webservice static void pushEvent(id eventid){
 googleCalendar_API.processEventList([Select Subject,
 StartDateTime, OwnerId, Location, IsAllDayEvent, Id,
 EndDateTime, DurationInMinutes, Description, ActivityDateTime,
 ActivityDate, google_id__c From Event where id = :eventid],
 false);
}
 //generic callout method to Google
 public static httpResponse callGoogle(String endpoint,String method, String body)
 {
     HttpRequest req = new HttpRequest();
     req.setEndpoint(endpoint);
     req.setMethod(method);
     req.setCompressed(false);
     req.setHeader('User-Agent','learnApex API');
     req.setHeader('Encoding','iso-8859-1');
     req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
     req.setTimeout(120000);//max timeout
     if( body != null )
     { //should be null if a GET
     req.setBody(body);
     req.setHeader('Content-length',
     string.valueOf(body.length()));
     }
     HttpResponse res = new http().send(req);
     return res;
 }
 public static PageReference loginRequestPage
 (String redirectURI, String state){
 //set the endpoint for authorization requests per
 //Google documentation
 PageReference p =
 new PageReference
 ('https://accounts.google.com/o/oauth2/auth');

 //add in all necessary parameters
//Determines if the Google Authorization Server returns an authorization code (code), or an opaque access token (token)

 p.getParameters().put('response_type','code');
//our client id
 p.getParameters().put('client_id',GOOGLE_API_CLIENT_ID);
 //our authorized redirect uri
 p.getParameters().put('redirect_uri',redirectURI);
//this forces our user to accept the app permissions //every time they visit this url

 p.getParameters().put('approval_prompt','force');

 //which permissions are we requesting?
 p.getParameters().put('scope',GOOGLE_CALENDAR_SCOPE);

//This optional parameter is used for anything you want //Google to return in its reply so you can use it.

 p.getParameters().put('state',state);
//this will allow us to log in without the user's //involvment
 p.getParameters().put('access_type','offline');
 return p;
 }
 public static map<String, list<calloutWrapper>> wrapEventsByOwner(List<Event> eventList, boolean deleting){
 //while we're at it, we'll convert to our wrapper
 map<String, list<calloutWrapper>> ownerMap = new
 map<String, list<calloutWrapper>>();
 //you can ignore the for loop, or follow along
 for ( Event e : eventList ){
 //Google requires all events to have a start and end
 //if our Salesforce event is incomplete, we can't use it
 if ( e.StartDateTime != null &&
 e.EndDateTime != null ){
 //new callout wrapper
 calloutWrapper w = new calloutWrapper(e);
 //set the method; if this event has a Google
 //id, then we want to update (PATCH) rather
 //than insert (POST); if deleting, we want
 //to delete
 w.Method =
 (string.isnotBlank(w.googleEventId))?
 ((deleting)?'DELETE':'PATCH'):
 'POST';
 //if owner already has events, add to list
 if ( ownerMap.containsKey(e.OwnerId))
 ownerMap.get(e.OwnerId).add(w);
 //otherwise new list for owner
 else ownerMap.put(e.OwnerId, new
 list<calloutWrapper>{w});
 }
 }
 return ownerMap;
}
public static void processEventList( list<Event> eventList,
boolean deleting){
 //generate a map of all events by ownerid
 //we'll need this because Google only
//lets us work with 1 user at a time
 map<String, list<calloutWrapper>> eventsByOwnerId =
 wrapEventsByOwner(eventlist,false);
 //list to collect events for update; new Google events will
 //have ids for us to store.
 List<Event> eventUpdates = new List<Event>();
 //for every owner
 for (string userId : eventsByOwnerId.keyset()){
 //refresh user Google Credentials, and store in userMap
 //userMap.put(userid,refreshToken(usermap.get(userid)));
 //send the request in one fel swoop
 //we have a method (shown after this) to construct
 //the actual HttpRequest we need
 httpResponse res = new
 http().send(buildRequest(userMap.get(userid),
 eventsByOwnerId.get(userid)));
 //retrieve response body for work
 String resBody = res.getBody();
 //debug the response; in case something goes wrong
 system.debug(resbody);
 //what's the boundary Google is using?
 String googBoundary =
 resBody.subStringBefore('Content-Type:');
 //use that boundary to split the response
 List<String> parts = resBody.split(googBoundary);
 //for every split part of the response by boundary
 for ( String p : parts ){
 //if this is an event response
 if ( p.contains('Content-ID: <response-') ){
 //add event to list for update with its Google Id
 Event e = new Event(Id =
 p.subStringBetween(
 'Content-ID: <response-','>'));
 e.Google_Id__c =
 p.subStringBetween('"id": "','"');
 eventUpdates.add(e);
 }
 }
 //as long as we aren't deleting
 if (!eventUpdates.isEmpty() && !deleting)
 update eventUpdates;
 }
 }
 public static HttpRequest buildRequest(User u,
 list<calloutWrapper> eventList){
httpRequest req = new httpRequest();
 //boundary to be used to denote individual events in our batch
 //this can be anything, since this is a use case, foobar :)
 String boundary = '______________batch_foobarbaz';
 //let Google know what our boundary is
 req.setHeader('Content-Type','multipart/mixed;boundary='+boundary);
 //add the access token as our authentication
 //note the space after Bearer
 req.setHeader('Authorization','Bearer '+u.Google_Access_Token__c);
 req.setMethod('POST');
 //we're sending a batch request, so we have a special endpoint
 req.setEndpoint('https://www.googleapis.com/batch');
 //max timeout
 req.setTimeout(120000);
 //construct our body
 String reqBody = '';
 //for every wrapped event
 for ( calloutWrapper e : eventList ){
 //start every event with a boundary
 reqBody += '--'+boundary+cr;
 //define type
 reqBody += 'Content-Type: application/http'+cr;
 //identify with our Salesforce id
 reqBody +='Content-ID: <'+e.salesforceEventId+'>'+cr+cr;
 //what are we doing to this event? insert,update,delete?
 //aka post,patch,delete
 reqBody += e.Method+' ';
 //identify the calendar, by email address
 reqBody += '/calendar/v3/calendars/'+
 encodingUtil.urlEncode(
 u.google_email__c,'UTF-8');
//add in the path for events on calendars
 reqBody += '/events';
 //need an id to delete / update
 if ( string.isNotBlank(e.GoogleEventId) &&
 (e.Method == 'PATCH' || e.Method == 'DELETE')){
 reqBody += '/'+e.googleEventId;
 }
 reqBody += cr+
'Content-Type: application/json;charset=UTF-8'+cr;
 //delete requests don't need these
 if ( e.method != 'DELETE' ){
 reqBody += 'Content-Length: '+e.Body.length()+cr;
 reqBody += cr;
 reqBody += e.Body;
 }
 reqBody += cr;
 }
 //close off our batch request with a boundary
 reqBody += '--'+boundary+'--';
 // for debugging, let's see what we've got
 system.debug(reqBody);
 //set the body
 req.setBody(reqBody);
 //be good and set required length header
 req.setHeader(
'Content-Length',string.valueOf(reqBody.length()));
 return req;
}
public static String compileBodyFromEvent(Event e){
 //we're building a JSON body manually!
 String body = '{'+cr+' "end": {'+cr;
 if (e.isalldayevent){
 body += ' "date": "'+ e.StartDateTime.formatgmt('yyyy-MM-dd')
 +'"'+cr;
 }
 else {
 body += ' "dateTime": "'+
 convertDateTimeToString(e.EndDateTime) +'"'+cr;
 }
 body += ' },'+cr+' "start": {'+cr;
 if (e.isalldayevent){
 body += ' "date": "'+ e.StartDateTime.formatgmt('yyyy-MM-dd')
 +'"'+cr;
 }
 else{
 body += ' "dateTime": "'+
 convertDateTimeToString(e.StartDateTime) +'"'+cr;
 }
 body += ' },'+cr;
 if ( string.isNotBlank(e.Subject) ){
 body += ' "summary": "'+ e.Subject +'",'+cr;
 }
 if ( string.isNotBlank(e.Description) ){
 body += ' "description": "'+
 e.Description.replace('\n','\\n').replace('\r','\\r')
 +'",'+cr;
 }
 if ( string.isNotBlank( e.Location ) ){
 body += ' "location": "'+ e.Location +'",'+cr;
 }
//we've been blindly adding returns
 body = body.subStringBeforeLast(',');
 body += '}'+cr;
 return body;
 }
 public static String convertDateTimeToString(DateTime dt){
 //retrieve the user's timezone and calculate offset
 TimeZone tz = UserInfo.getTimeZone();
 Integer x = tz.getOffset(dt)/3600000;
 String z = '';
 if ( x > 0 ) z += '+';
 else z += '-';
 //if less than 9, prepend a 0, since 2 digit expected
 if ( x > 9 || x < -9 ) z += math.abs(x);
 else z += '0'+math.abs(x);
 z += ':00';
 //return string formatted datetime+timezone offset
 return dt.format('yyyy-MM-dd\'T\'HH:mm:ss'+z);
}
}
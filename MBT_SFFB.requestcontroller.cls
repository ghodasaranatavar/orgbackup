public with sharing class requestcontroller 
{
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
 }
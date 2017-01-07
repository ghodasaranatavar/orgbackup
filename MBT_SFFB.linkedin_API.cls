/**

@author Innodel Technologies PVT LTD
@date 19 th OCT 2016
@description Class is for Authentication request Methods to linked IN
LINKEDIN_SCOPE: basicprofile, Email ID, Company Admin, Sharing Post.
Callback to : https://c.ap2.visual.force.com/apex/linkedincallbackurlvfpage
User Account of linked in is staff.innodel@gmail.com
*/
global class linkedin_API {
    public static String LINKEDIN_API_CLIENT_ID ='81qw4djajyu16b'; 
    public static String LINKEDIN_API_CLIENT_SECRET ='r7V840RC7B6q7xGk';
    public static String LINKEDIN_SCOPE ='r_basicprofile r_emailaddress rw_company_admin w_share'; 
    public static String SF_CALLBACK_PAGE ='https://c.ap2.visual.force.com/apex/linkedincallbackurlvfpage';    
    public static String LINKEDIN_STATE='hghg54DFVkjkSKSas4s53';
    public static String LINKEDIN_AUTHORIZATION_URL='https://www.linkedin.com/uas/oauth2/authorization';
    public static String LINKEDIN_ACCESSTOKEN_URL='https://www.linkedin.com/oauth/v2/accessToken';
    public static String LINKEDIN_ACCESSTOKEN {get;set;}
    public static String LINKEDIN_OWNDETAIL='https://api.linkedin.com/v1/people/~:(id,first-name,last-name,formatted-name,email-address,picture-url)?oauth2_access_token=';
    public static String LINKEDIN_OWNDETAIL_DATA='';
    public static String LINKEDIN_REQUEST_CONTENTTYPE='application/json';
    public static String LINKEDIN_REQUEST_FORMAT='x-li-format';  
    public static String LINKEDIN_JSONTOKEN='';
    public static String LINKEDIN_SHAREPOST='https://api.linkedin.com/v1/people/~/shares?oauth2_access_token='; 
    public linkedin_API()
    {
        // Default constructor
        
    }
    /**
        @date 19 th OCT 2016
        @description Method is to get authentication screen and user should insert Username password for oauth 2.0.
        @param LINKEDIN_STATE is used for state that continuosly stays with App. 
    */
    public static PageReference loginRequestToLinkedin()
     { 
         
         PageReference p = new PageReference(LINKEDIN_AUTHORIZATION_URL);
         p.getParameters().put('response_type','code');
         p.getParameters().put('client_id',LINKEDIN_API_CLIENT_ID); 
         p.getParameters().put('redirect_uri',SF_CALLBACK_PAGE); 
         p.getParameters().put('scope',LINKEDIN_SCOPE);
         p.getParameters().put('state',LINKEDIN_STATE);
         return p;
     }
      /**
        @date 24 th OCT 2016
        @description deserialize the Json passed in this method.
        @param jsonstring - Json string that need to parse
        @param fieldname - field name that is included into the json string. 
    */
     public static String deserializeLinkedINfield(string jsonstring,string fieldname) 
    {
        JSONParser parser = JSON.createParser(jsonstring);
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&(parser.getText() == fieldname)) 
            {              
                parser.nextToken();
               LINKEDIN_JSONTOKEN=parser.getText();
             
            }
        }
        return LINKEDIN_JSONTOKEN;
    }  
     /**
        @date 24 th OCT 2016
        @description Method is to get Access token and send a post request to Linked In for Token 
    */
     public static String gotAccessTocken(String code,String state)
     { 
         
         if(LINKEDIN_STATE==state)
         {
             // valid request from the linked in not tempered
             PageReference p = new PageReference(LINKEDIN_ACCESSTOKEN_URL);
             p.getParameters().put('grant_type','authorization_code');
             p.getParameters().put('code',code);
             p.getParameters().put('redirect_uri',SF_CALLBACK_PAGE);
             p.getParameters().put('client_id',LINKEDIN_API_CLIENT_ID);
             p.getParameters().put('client_secret',LINKEDIN_API_CLIENT_SECRET);
             String body = p.getURL();
             body = body.subStringAfter('?');
             HttpRequest req = new HttpRequest();
             req.setEndpoint(LINKEDIN_ACCESSTOKEN_URL);
             req.setMethod('POST');
             req.setCompressed(false);
             req.setHeader('HOST','www.linkedin.com');
             req.setHeader('Encoding','iso-8859-1');
             req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             req.setTimeout(120000);//max timeout
             if(body != null )
             { 
                 req.setBody(body);
                 req.setHeader('Content-length',string.valueOf(body.length()));
             }
             HttpResponse res = new http().send(req);
             //return res.getBody();
             return LINKEDIN_ACCESSTOKEN= deserializeLinkedINfield(res.getBody(),'access_token'); // retrives access token and returns it
         }
         return '';
         
         
     }
     public static String getOwnProfile(String token)
     {
             HttpRequest req = new HttpRequest();
             req.setEndpoint(LINKEDIN_OWNDETAIL+token+'&format=json');
             req.setMethod('GET');
             req.setCompressed(false);
             req.setHeader('HOST','www.linkedin.com');
             req.setHeader('Encoding','iso-8859-1');
             req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
             req.setTimeout(120000);//max timeout
             HttpResponse res = new http().send(req);
             return LINKEDIN_OWNDETAIL_DATA=res.getBody();
             
     }
     public static String getOwnFormatedName(string linkedinowndata)
     {
         return deserializeLinkedINfield(linkedinowndata,'formattedName');
     }
     public static String getOwnPhoto(string linkedinowndata)
     {
         return deserializeLinkedINfield(linkedinowndata,'pictureUrl');
     }
     public static String getOwnEmail(string linkedinowndata)
     {
         return deserializeLinkedINfield(linkedinowndata,'emailAddress');
     }
     public static String sharePost(String post,String token)
     {
         linkedinpostshare_API objlinkedinpostshare_API = new linkedinpostshare_API();         
         linkedinpostshare_API.Visibility objVisibility = new linkedinpostshare_API.Visibility();
              
         objVisibility.code='anyone';
         objlinkedinpostshare_API.comment=post;         
         objlinkedinpostshare_API.visibility=objVisibility;       
              
         String jsonBody = json.serialize(objlinkedinpostshare_API);        
         HttpRequest req = new HttpRequest();
         req.setEndpoint(LINKEDIN_SHAREPOST+token+'&format=json');
         req.setMethod('POST');
         req.setCompressed(false);
         req.setHeader('HOST','www.linkedin.com');
         req.setHeader('Encoding','iso-8859-1'); 
         req.setHeader('Content-Type', LINKEDIN_REQUEST_CONTENTTYPE);
         req.setHeader('x-li-format', 'json');         
         req.setTimeout(120000);//max timeout
          if(jsonBody != null )
             { 
                 req.setBody(jsonBody);
                 req.setHeader('Content-length',string.valueOf(jsonBody.length()));
             }
             HttpResponse res = new http().send(req);
            // return jsonBody;
           return res.getBody();
         // return token;
       
     }
    
}
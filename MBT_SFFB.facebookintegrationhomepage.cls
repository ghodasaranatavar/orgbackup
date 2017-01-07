/**
@author Innodel Technologies PVT LTD
@date 9 th NOV 2016
@description Class is used for API calls for own Profile data that shows own profile.
*/
public with sharing class facebookintegrationhomepage
{
    public static string ownprofile {get;set;}
    public string ownname {get;set;}
    public static string ownid {get;set;}
    public string ownemail {get;set;}
    public string ownformatedname{get;set;}
    public string ownphoto{get;set;}
    public string wellcomestring {get;set;}
    public string profilepic{get;set;}
    public static string accesstoken{get;set;}
    public string shares{get;set;}
/**
@date 9 th NOV 2016
@description Method is used to retrive profile data using accesstoken and adds.
*/
    public PageReference getmyprofiledata()
    {        
        PageReference  p = ApexPages.currentPage(); 
        accesstoken = p.getParameters().get('access_token');
        ownprofile = facebookAPI.getownprofile(accesstoken);
        ownname =facebookAPI.getownname(ownprofile);
        wellcomestring ='Welcome ' + ownname + ' !';
      //  ownid =facebookAPI.getownid(ownprofile);
        //ownphoto = facebookAPI.getowncover(ownprofile);
        ownemail =facebookAPI.getownemail(ownprofile);
        profilepic =facebookAPI.getownpicture(ownprofile);
        return null;
        
    }
     /*@RemoteAction
    public static string shareonfacebook(String post,String access_token)
    {
        // ownprofile = facebookAPI.getownprofile(access_token);
        // ownid =facebookAPI.getownid(ownprofile);   
        return facebookAPI.sharepostownprofile(post,access_token);
    }*/
    @RemoteAction
    public static string postcomment(string post)
    {
        facebookpagecomment__c objfbcmnt = new facebookpagecomment__c();        
        objfbcmnt.post__c = post;
        objfbcmnt.facebookpageid__c='page-0001';
        insert objfbcmnt;
        return 'sucess';
    }
    @RemoteAction
    public static list<facebookpagecomment__c> getposts(string id)
    {
        return [select comments__c,post__c from facebookpagecomment__c where facebookpageid__c =:id];
    }
   
}
/**

@author Innodel Technologies PVT LTD
@date 9 th NOV 2016
@description Class calls Integration Calling to Facebook. Starting point of integration to facebook.
*/
public with sharing class facebookIntegrationCalling
{
    public static string client_id {get;set;}
    public static Facebook_oauth_Setting__c objfb_oauth_setting {get;set;}
    public facebookIntegrationCalling()
    {
        // default constructor           
       
    }
    /**
@date 9 th NOV 2016
@description Method is used to retrieve Client ID from the Object on Page load and show login button if record Exist.
*/
   @RemoteAction
   public static String getclientid()
   {
        objfb_oauth_setting= [select client_id__c from Facebook_oauth_Setting__c limit 1]; 
        if(objfb_oauth_setting!=null)
        {
            client_id =objfb_oauth_setting.client_id__c;
        }
        else
        {
            client_id ='Null';
        } 
        return client_id;
   }    
    
}
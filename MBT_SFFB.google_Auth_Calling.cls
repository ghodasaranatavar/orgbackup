/**

@author Innodel Technologies PVT LTD
@date 26 th OCT 2016
@description Authentication code , Autherisation
*/
public with sharing class google_Auth_Calling
{
    public google_Auth_Calling()
    {
         //default constructor
    }
    public PageReference call_Auth()
    {
        return googleCalendarIntegration_API.Request_Google_oAuth();
    }
}
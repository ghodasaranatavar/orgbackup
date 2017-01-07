/**

@author Innodel Technologies PVT LTD
@date 19 th OCT 2016
@description Class is for Authentication request to linked IN

*/
public with sharing class linkedinCallingClass 
{

    
    public linkedinCallingClass()
    {
        
         // default constructor
         
    }
    /**
        @author Innodel Technologies PVT LTD
        @date 19 th OCT 2016
        @description Class is for Authentication request to linked IN using linkedin_API Class Methods to access.
    */
    public pagereference requestAuthorizationToLinkedIn()
    {
         return linkedin_API.loginRequestToLinkedin();
        
    }
    
}
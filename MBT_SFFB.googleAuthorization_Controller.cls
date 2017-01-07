public with sharing class googleAuthorization_Controller {

 //our email variable
 public string googleEmail {get;set;}
  //to store our code for dynamic rendering
 public string code {get;set;}
 //to store our user record
 public User u {get;set;}
 
 //constructor
 public googleAuthorization_Controller() {
 //preset user's email
 googleEmail = userInfo.getUserEmail();
 }
 
 //what our command button will do
  public pagereference requestAuthorization(){
 return googleCalendar_API.loginRequestPage(
 googleCalendar_API.SF_AUTH_PAGE,
 googleEmail);
 }
 
}
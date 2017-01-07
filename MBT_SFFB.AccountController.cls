global with sharing class AccountController {
public List<SelectOption> accountLst {get;set;}
public String selectedAccount{get;set;}
 
public List<Account> getListOfAccounts()
{
           List<Account> AccountList = [select id,Name,Type,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,BillingLatitude,BillingLongitude from Account] ;
           System.debug('Accounts'+AccountList.size());
           List<Account> Accountlistdynamic = new List<Account>();
           for(Account acc : AccountList )
           {
                      Accountlistdynamic .add(acc);
           }
          return Accountlistdynamic;
}



    public String selectedaccountId { get; set; }

    public AccountController() {
    }
}
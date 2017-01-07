@isTest
public class DuplicateAccountTestClass {
   
   public static testMethod void testAccountDuplicateTrigger() {
        Account existingAccount = new Account(Name = 'John');
        insert existingAccount;
        
        Account duplicateAccount = new Account(Name = 'John');
        try {
           insert duplicateAccount;
        }
        catch (Exception e) {
           System.debug('We want to see this.  This means the trigger is working.');
        } 
   }
}
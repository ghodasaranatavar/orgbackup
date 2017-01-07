@isTest
public class  parsingtriggerTest {
    public static testmethod void test1() {
        LHBuyerCase__c objtask = new LHBuyerCase__c();
        objtask.Name='name1';
        objtask.Description__c='hjhjhhjhj hjhjhjhjh asghghg@gmail.com asdghghg' +'\r\n'+'ghghghg gyhgghg@gmail.com';
        Test.startTest();
        insert objtask;
        
        objtask.Description__c='hjhjhhjhj hjhjhjhjh asghghg@gmail.com asdghghg' +'\r\n'+'ghghghg gyrewewewghg@gmail.com';
        update objtask;
        Test.stopTest();
    }
}
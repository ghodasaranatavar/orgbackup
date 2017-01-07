@isTest
public class testRandomizer_API{
static testMethod void testRandomizer() {
          test.startTest();
          Integer testInt = Randomizer_API.getRandomNumber(10);          
          List<String> testStringList = new List<String>();
          testStringList.add('one');
          testStringList.add('two');
          testStringList.add('three');
          String testString = Randomizer_API.getRandomString(testStringList);          
          test.stopTest();
          
     }
     }
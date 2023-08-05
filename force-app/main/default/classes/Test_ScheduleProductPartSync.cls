/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 08-05-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class Test_ScheduleProductPartSync {
    @isTest
    public static void testProductPart(){
        Product2 productObj= new Product2();
        productObj.Name= 'Test Part';
        productObj.ProductCode= '1234RT';
        productObj.IsActive= true;
        insert productObj;
        
        List<SQX_Part__c> partList= new List<SQX_Part__c>();
        SQX_Part__c partObj= new SQX_Part__c();
        partObj.Name = 'Test Part';
        partObj.Part_Number__c = '1234RT';
        partObj.Active__c= True;
        partList.add(partObj);
        
        SQX_Part__c partObj2= new SQX_Part__c();
        partObj2.Name = 'Test Part1';
        partObj2.Part_Number__c = '1234RT111';
        partObj2.Active__c = True;
        partObj2.Product__c = productObj.Id;
        partList.add(partObj2);
        
        insert partList;
        
        Test.startTest();
        String success= ScheduleProductPartSync.schedulePartSync();
        
        List<SQX_Part__c> partsList= [Select Id,Product__c From SQX_Part__c WHERE Product__c != null];
        system.Assert(success== 'Not schedule');
        Test.stopTest();
    }
    
}
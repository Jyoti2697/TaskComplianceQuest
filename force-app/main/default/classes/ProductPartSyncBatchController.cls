/**
 * @description       : Batch class to sync the Parts and Products.
 * @author            : Jyoti Chahal
 * @last modified on  : 08-05-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ProductPartSyncBatchController implements Database.Batchable<SObject>{
    /**
    * @description: (Start) this method is used to query the active Parts.
    * @author Jyoti Chahal | 08-05-2023 
    * @param batchContext 
    * @return Database.QueryLocator 
    **/
    public Database.QueryLocator start(Database.BatchableContext batchContext){
        String query = 'SELECT Id, Name,Active__c,Part_Number__c, Product__c FROM SQX_Part__c WHERE Active__c = true';
        return Database.getQueryLocator(query);
    }
    /**
    * @description: (Execute) this method is used to update the parts and insert the Product based on requirement.
    * @author Jyoti Chahal | 08-05-2023 
    * @param batchContext 
    * @param partList 
    **/
    public void execute(Database.BatchableContext batchContext,List<SQX_Part__c> partList){
        try{
        Set<String> partsName= new Set<String>();
        Set<String> partsNumber= new Set<String>();
        for(SQX_Part__c partObj: partList){
            partsName.add(partObj.Name);
            partsNumber.add(partObj.Part_Number__c);
        }
        List<SQX_Part__c> updateParts= new List<SQX_Part__c>();
        Map<Id,Product2> insertProduct= new Map<Id,Product2>();
        Map<String,Product2> existingProductMap= new Map<String,Product2>();
        //putting value in map with the same Product Name and code with Parts name and NUmber.
        for(Product2 productObj: [Select Id,Name,ProductCode From Product2 Where Name IN: partsName AND ProductCode IN: partsNumber LIMIT 10000]){
            existingProductMap.put(productObj.Name + productObj.ProductCode, productObj);
        }
        for(SQX_Part__c partOBj: partList){
            if(existingProductMap.containsKey(partOBj.Name + partOBj.Part_Number__c)){
                partOBj.Product__c= existingProductMap.get(partOBj.Name + partOBj.Part_Number__c).Id;
                updateParts.add(partOBj);
            }
            else{
                Product2 productObj= new Product2();
                productObj.Name= partOBj.Name;
                productObj.ProductCode= partOBj.Part_Number__c;
                productObj.IsActive= partOBj.Active__c;
                insertProduct.put(partOBj.Id,productObj);
            }
        }
        // chechecking the update and create permission 
        if(!insertProduct.isEmpty() && (Schema.sObjectType.Product2.isCreateable())){
            insert insertProduct.values();
            //Here getting the Product Id to set the associate products to parts
            for(Id eachPartId: insertProduct.keySet()){
                updateParts.add(new SQX_Part__c(Id= eachPartId,Product__c = insertProduct.get(eachPartId).Id));
            }
        }
        if(!updateParts.isEmpty() && (Schema.sObjectType.SQX_Part__c.isUpdateable())){
            update updateParts;
        }
        }
        catch(Exception ex){
            System.debug('Error::::'+ex.getMessage()+' line number:::'+ex.getLineNumber());
        }
    }
    /**
    * @description: (finish) this method is for the post-processing logic.
    * @author Jyoti Chahal | 08-05-2023 
    * @param batchContext 
    **/
    public void finish(Database.BatchableContext batchContext){
        //this method is for post-processing logic if needed.
    }
}
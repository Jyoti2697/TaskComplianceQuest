/**
 * @description       : Scheduler class to sync the Part and Product at 6 am.
 * @author            : Jyoti Chahal
 * @group             : 
 * @last modified on  : 08-05-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ProductPartSyncScheduler implements Schedulable{
    /**
    * @description: this method used to execute the batch class and check the profile and permission set.
    * @author Jyoti Chahal | 08-05-2023 
    * @param context 
    **/
    public void execute(SchedulableContext context) {
        //Here getting the profile Name System Admin and Permission set CQ Product Admin
        Id profileId= UserInfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<PermissionSetAssignment> permissionSetAssList = [SELECT AssigneeId, PermissionSet.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'CQ_Product_Admin' AND AssigneeId=:UserInfo.getUserId() WITH SECURITY_ENFORCED];
        //Here checking the Profile name and Permission set according to the requirement to execute the batch class.
        if(profileName == 'System Administrator' && !permissionSetAssList.isEmpty()){
            ProductPartSyncBatchController syncBatch= new ProductPartSyncBatchController();   // Batch class
            Database.executeBatch(syncBatch);
        }
    }
}
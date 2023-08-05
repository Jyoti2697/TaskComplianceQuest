/**
 * @description       : apex class to schedule the Scheduler class at 6 am 
 * @author            : Jyoti Chahal
 * @group             : 
 * @last modified on  : 08-05-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ScheduleProductPartSync {
    public static String schedulePartSync() {
        try{
        ProductPartSyncScheduler scheduleSync= new ProductPartSyncScheduler();
        String cronExp='0 0 0,6 ? * * *';
        system.schedule('Schedule Product and Part Sync', cronExp, scheduleSync);
        return 'schedule';
        }
        catch(Exception ex){
            system.debug('Error::::'+ex.getMessage());
            return 'Not schedule';
        }
    }
}
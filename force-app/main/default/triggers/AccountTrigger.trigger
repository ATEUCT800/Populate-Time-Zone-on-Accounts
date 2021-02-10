trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    if(trigger.isAfter && trigger.isUpdate){
      AccountTrH.afterUpdate(trigger.new, Trigger.oldMap);
    } else if(trigger.isAfter && trigger.isInsert){
      AccountTrH.afterInsert(trigger.new);
    }
  }
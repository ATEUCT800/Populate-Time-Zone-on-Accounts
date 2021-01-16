trigger AccountTrigger on Account (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.IsInsert) {
            AccountTrH.afterInsert(trigger.new);
        }
    }
}
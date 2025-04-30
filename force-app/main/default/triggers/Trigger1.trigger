trigger Trigger1 on Account (before insert) {
    System.debug('isExecuting '+'isInsert '+'isUpdate '+'isDelete '+'isBefore '+'isAfter '+'isUndelete '+'size '+'new '+'newMap '+'old '+'oldMap');
}
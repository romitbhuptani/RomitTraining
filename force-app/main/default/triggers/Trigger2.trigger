trigger Trigger2 on Lead (before insert) {
    for(Lead lead : Trigger.new){
        lead.Rating = 'Hot';
    }
}
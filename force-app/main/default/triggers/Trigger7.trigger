trigger Trigger7 on Account (before insert) {
    for(Account acc : Trigger.New){
        String name = acc.Name;
        acc.Name = 'Mr. / Mrs. ' + name;
    }
}
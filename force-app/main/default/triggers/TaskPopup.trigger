trigger TaskPopup on Task (after update) {
    list<taskEvent__e> events = new list<taskEvent__e>();
    for(task tasks : trigger.new)
    {
        taskEvent__e event = new taskEvent__e();
        if(tasks.status == 'Completed')
        {
          
            events.add(event);
        }
    }
        if (!events.isEmpty()) {
        EventBus.publish(events);
    }
}
public with sharing class MessageItem {

    public String filedName {get;set;}
    public Object oldValue {get;set;}
    public Object newValue {get;set;}

    public MessageItem(String filedName, Object oldValue, Object newValue) {
        this.filedName = filedName;
        this.oldValue = oldValue;
        this.newValue = newValue;
    }
}
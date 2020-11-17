import { LightningElement, api } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ListenerComponent extends LightningElement {
    channelName = '/event/UpdateAccountPE__e';
    subscription = {};
    @api recordId;

    connectedCallback() {  

        const messageCallback = (response) => {
            var message = response.data.payload.Info__c;
            var eventRecordId = response.data.payload.AccountId__c;
            if(eventRecordId == this.recordId){
                this.showToast('Account changes', message);
            }
        };
        
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response;
        });

        this.registerErrorListener();
    }

    registerErrorListener() {
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }

    showToast(title, message) {
        const event = new ShowToastEvent({title, message});
        this.dispatchEvent(event);
    }

    //The call is not happening?
    disconnectedCallback() {
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
        });
    }

}
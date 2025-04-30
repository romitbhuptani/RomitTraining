import { LightningElement } from 'lwc';

export default class Test extends LightningElement {
    connectedCallback() {
        // Adding event listener for keydown when component is connected
        console.log('connected');
        
        window.addEventListener('keydown', this.handleKeyDown);
    }

    disconnectedCallback() {
        // Remove the event listener when the component is removed from the DOM
        window.removeEventListener('keydown', this.handleKeyDown);
    }

    handleKeyDown(event) {
        // Check for Shift + Backspace or Shift + Delete key combinations
        console.log('Key pressed:',event.key);
        
        
    }
}
// expandableComponent.js

import { LightningElement, api, track } from 'lwc';

export default class ExpandableComponent extends LightningElement {
    @api questionHeader;
    @api answerBody;
    @track isExpanded = false;

    get contentClass() {
        return this.isExpanded ? 'content expanded' : 'content';
    }

    toggleExpansion() {
        this.isExpanded = !this.isExpanded;
        
    }
}
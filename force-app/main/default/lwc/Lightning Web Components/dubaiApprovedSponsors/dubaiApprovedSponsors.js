// import { LightningElement,wire } from 'lwc';
// import getSponsor from "@salesforce/apex/SponsorController.getSponsor";
// import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';
// export default class DubaiApprovedSponsors extends LightningElement {
//     selectedEventId;
//     sponsorInformation;
//     @wire(getDubaiDreaminEventId)
//     wiredEventId({ error, data }) { 
//     if (data) {
        
//         console.log('Dubai Dreamin Event ID:', data);
//         this.selectedEventId=data;
//     } else if (error) {
//         console.error('getDubaiDreaminEventId Error:', error);
//     }
// }
// @wire(getSponsor, { eventId: '$selectedEventId' })
// wiredData({ error, data }) {
//     if (data) {
//         this.sponsorInformation = data
//     } else if (error) {
//         console.error('Sponsor Error:', error);
//     }
// }
// }





import { LightningElement, wire } from 'lwc';
import getSponsor from "@salesforce/apex/SponsorController.getSponsor";
import getDubaiDreaminEventId from '@salesforce/apex/EventController.getDubaiDreaminEventId';

export default class DubaiApprovedSponsors extends LightningElement {
    selectedEventId;
    sponsorInformation;
    showSponsors = false;
    @wire(getDubaiDreaminEventId)
    wiredEventId({ error, data }) {
        if (data) {
            this.selectedEventId = data;
        } else if (error) {
            console.error('getDubaiDreaminEventId Error:', error);
        }
    }

    @wire(getSponsor, { eventId: '$selectedEventId' })
    wiredData({ error, data }) {
        if (data) {
            // Organize sponsor data by sponsorship level
            this.sponsorInformation = this.organizeSponsorData(data);
            this.showSponsors = data && data.length;
            // if(this.sponsorInformation!=null){this.showSponsors = true;} 
        } else if (error) {
            console.error('Sponsor Error:', error);
        }
    }

    // Organize sponsor data by sponsorship level
    // organizeSponsorData(data) {
    //     const sponsorMap = new Map();
    //     data.forEach(sponsor => {
    //         const sponsorshipLevel = sponsor.sponsorshipLevel;
    //         if (!sponsorMap.has(sponsorshipLevel)) {
    //             sponsorMap.set(sponsorshipLevel, []);
    //         }
    //         sponsorMap.get(sponsorshipLevel).push(sponsor);
    //     });

    //     return Array.from(sponsorMap, ([sponsorshipLevel, sponsors]) => ({ sponsorshipLevel, sponsors }));
    // }
    // Organize sponsor data by sponsorship level
     // Organize sponsor data by sponsorship level
     organizeSponsorData(data) {
        if(data){
            console.log('Sponsor data:: ',data);
            // this.showSponsors = true;

            const sponsorMap = new Map();
            data.forEach(sponsor => {
                const sponsorshipLevel = sponsor.sponsorshipLevel;
                if (!sponsorMap.has(sponsorshipLevel)) {
                    sponsorMap.set(sponsorshipLevel, []);
                }
                sponsorMap.get(sponsorshipLevel).push(sponsor);
            });
            return Array.from(sponsorMap, ([sponsorshipLevel, sponsors]) => ({ sponsorshipLevel, sponsors }));
        }
        else{
            console.log('No data for Sponsor',error);
        }
        
    }

    // Sort sponsor information by sponsorship level
    sortSponsorInformation() {
        this.sponsorInformation.sort((a, b) => {
            const order = ['PLATINUM', 'GOLD', 'SILVER', 'BRONZE'];
            return order.indexOf(a.sponsorshipLevel) - order.indexOf(b.sponsorshipLevel);
        });
    }

}
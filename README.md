# Dubai Dreamin'

## Overview
The Dubai Dreamin' project is a Salesforce-powered event management application tailored for a large-scale conference. It integrates diverse Salesforce tools and features, including attendees, speakers, payment processing, and approval workflows, making it an ideal solution for streamlined event operations.

## Key Features

### **1. Apex Classes**
Apex classes form the backbone of this project, providing robust backend functionality:
- **Attendee Management:** End-to-end operations for attendee data and session registrations.
- **Speaker Management:** Handles speaker details, session assignments, and updates.
- **Payment Processing:** Supports seamless integration with Stripe and PayPal.
- **Approval Logic:** Automates workflows such as speaker approvals and refund requests.
- **Email Automation:** Sends automated emails for confirmations, reminders, and updates.

### **2. Lightning Web Components (LWC)**
Custom LWCs deliver an intuitive and dynamic user interface:
- **Attendee Dashboard:** Personalized view for managing registrations and payments.
- **Speaker Portal:** Tools for speakers to manage session details and upload materials.
- **Session Browser:** Enables attendees to browse, register, or modify session bookings.
- **Payment Gateway UI:** Secure, user-friendly interface for online payments.

### **3. Approval Processes**
Approval workflows enhance operational efficiency:
- Manage speaker session proposals.
- Oversee attendee cancellations and refunds.
- Approve special access and VIP privileges.

### **4. Flows**
Flows automate critical business processes:
- **Registration Workflow:** Simplifies attendee sign-ups and payments.
- **Speaker Onboarding Flow:** Automates speaker application submissions and approvals.
- **Feedback Surveys:** Collects post-event feedback via automated surveys.

### **5. Email Templates**
Predefined email templates for:
- Registration confirmations.
- Payment receipts.
- Session reminders.
- Post-event follow-ups.

### **6. Event-Specific Features**
- **Speakers:** Manage profiles, session schedules, and resource uploads.
- **Attendees:** Handle registrations, preferences, and communication.
- **Payments:** Secure processing via Stripe and PayPal APIs.
- **Session Management:** Enable attendees to manage session participation.

## Technical Overview

### **Data Model**
Custom objects tailored for this application:
- **Attendee Object:** Tracks attendee details, session registrations, and payments.
- **Speaker Object:** Manages speaker data and session assignments.
- **Session Object:** Stores session-specific details like topics, timing, and venues.
- **Payment Object:** Logs all financial transactions and statuses.

### **Customizations**
- **Custom Fields:** Tailored fields to capture specific data points.
- **Validation Rules:** Enforce data integrity and consistency.
- **Custom Settings:** Simplify and centralize configuration management.

### **Integrations**
- **Payment Gateways:** Secure and efficient integration with Stripe and PayPal.
- **Marketing Cloud:** Drive engagement through personalized email campaigns.

## Deployment Steps
1. **Clone the Repository:** Download the project files to your local system.
2. **Deploy Metadata:** Utilize Salesforce CLI or an IDE to deploy metadata components.
3. **Configure Payment Gateways:** Add Stripe and PayPal API keys in Custom Settings.
4. **Activate Flows:** Enable all required flows for seamless operation.
5. **Assign Permissions:** Ensure profiles and permission sets are correctly assigned.
6. **Conduct Testing:** Perform thorough testing to validate all functionalities.

## Why Choose This Solution?
This application provides a one-stop solution for event management, offering:
- User-friendly interfaces for both attendees and organizers.
- Streamlined workflows to save time and reduce errors.
- Secure payment handling and data management.

## Contact
For more information or collaboration opportunities, please contact:

**Fahad Yaseen**
Email: [fahadyaseen116@gmail.com](mailto:fahadyaseen116@gmail.com)

---

Submit this project on Upwork to showcase expertise in Salesforce development and event management solutions.





# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

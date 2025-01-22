trigger OpportunityClosedWonEmail on Opportunity (after update) {
    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    for (Opportunity opp : Trigger.new) {
        // Check if Opportunity is closed-won and it was not closed-won before
        if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won') {
            // Query the related Order and Order Products (OrderItems)
            List<Order> orders = [SELECT Id, Name, 
                                          (SELECT Product2.Name, Quantity, TotalPrice FROM OrderItems) 
                                   FROM Order 
                                   WHERE OpportunityId = :opp.Id];

            // If related orders and products exist, send the email
            for (Order order : orders) {
                if (order.OrderItems.size() > 0) {
                    // Prepare the email and use the Visualforce template
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[] { opp.Owner.Email }); // You can change the recipient
                    mail.setSubject('Order Product List for Opportunity: ' + opp.Name);
                    mail.setTemplateId('YOUR_TEMPLATE_ID'); // Replace with your Visualforce Email Template ID
                    mail.setWhatId(opp.Id);  // Opportunity record
                    mail.setTargetObjectId(opp.OwnerId); // The recipient's contact (Opportunity Owner)

                    // Add the email to the list to send
                    emailsToSend.add(mail);
                }
            }
        }
    }

    // Send the emails if any are prepared
    if (!emailsToSend.isEmpty()) {
        Messaging.sendEmail(emailsToSend);
    }
}
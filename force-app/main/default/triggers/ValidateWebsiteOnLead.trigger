trigger ValidateWebsiteOnLead on Lead (before insert, before update) {
    for (Lead lead : Trigger.new) {
        if (String.isNotBlank(lead.Website) && !lead.Website.startsWithIgnoreCase('www')) {
            lead.addError('The Website must start with "www". Please enter a valid URL.');
        }
    }
}
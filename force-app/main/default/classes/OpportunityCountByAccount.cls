public class OpportunityCountByAccount {
    // Method to count Opportunities associated with a given Account
    public static Integer countOpportunities(String accountId) {
        // Query Opportunities associated with the Account Id
        AggregateResult[] results = [
            SELECT AccountId, COUNT(Id) opportunityCount
            FROM Opportunity
            WHERE AccountId = :accountId
            GROUP BY AccountId
        ];
        
        // If results are returned, return the count
        if (!results.isEmpty()) {
            return (Integer) results[0].get('opportunityCount');
        } else {
            return 0; // Return 0 if no Opportunities are found
        }
    }

    // Example usage in anonymous Apex
    public static void exampleUsage() {
        // Replace with your Account Id
        String accountId = '001xx000003DHPqAA'; 
        
        Integer opportunityCount = countOpportunities(accountId);
        
        System.debug('Number of Opportunities for Account ' + accountId + ': ' + opportunityCount);
    }
}
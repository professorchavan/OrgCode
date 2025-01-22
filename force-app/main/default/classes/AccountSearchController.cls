public with sharing class AccountSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccountByName(String name) {
        return [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :('%' + name + '%')
            LIMIT 10
        ];
    }
}
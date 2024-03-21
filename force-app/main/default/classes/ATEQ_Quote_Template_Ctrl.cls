//ATEQ_Quote_Template_Ctrl 
public class ATEQ_Quote_Template_Ctrl {
	
    public Quote quote{get;set;}
    public ATEQ_Quote_Template_Ctrl(ApexPages.StandardController stdController) {
        String quoteId = ApexPages.currentPage().getParameters().get('id');
        quote = [SELECT Id, QuoteNumber, CreatedDate, Owner.Name, Owner.Email, Owner.Phone, Customer_Name__c, Customer_Address__c, Customer_Email__c,Customer_Phone__c, GrandTotal,
                    (SELECT Id, Product2.Name, Product2.Description, Product2.SKU__c, Quantity, UnitPrice, TotalPrice FROM QuoteLineItems) FROM Quote WHERE Id=:quoteId];
    }
    
}
// Class Name:CustomQuotePDFController//

public without sharing class CustomQuotePDFController {
    //private final Quote quote;
    public CustomQuotePDFController(ApexPages.StandardController stdController) {
        //this.quote = (Quote)stdController.getRecord();
    }
    /*public Quote getQuote() {
return quote;
}*/
    public PageReference saveToNotes() {
        String quoteId = ApexPages.currentPage().getParameters().get('id');
        System.debug('DEBUGX_entering saveToNotes()...');
        System.debug('DEBUGX saveToNotes() quote.Id : '+quoteId);
        PageReference newPage = new PageReference('/apex/ATEQ_Quote_Template');
        newPage.getParameters().put('id',quoteId);
        Blob pdfBody = newPage.getContentAsPDF();
        Quote quoteData = [SELECT Id, Name FROM Quote WHERE Id=:quoteId LIMIT 1];
        //Create Document
        ContentVersion cv = new ContentVersion(); 
        cv.Title = quoteData.Name +'.pdf';
        cv.PathOnClient = '/' + cv.Title;
        cv.VersionData = pdfBody;
        cv.IsMajorVersion = true; 
        insert cv;  
        //Creating Quote Pdf
        QuoteDocument quotedoc = new QuoteDocument(); 
        quotedoc.Document = pdfBody;                
        quotedoc.QuoteId = quoteId; 
        insert quotedoc; 
      	// Creating attachment
        Attachment attachment = new Attachment();
        attachment.ParentId = quoteId;
        attachment.Name = 'ATEQ_Quote.pdf';
        attachment.Body = cv.VersionData; 			
        attachment.ContentType = 'application/pdf';
        insert attachment;
        System.debug('DEBUGX insert attachment id : '+attachment.Id); 
        return new PageReference('/' + quoteId);
  
        
    
    }    
    
    public PageReference sendEmail() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'sucharithareddy504@gmail.com' });
        email.setSubject('Quote PDF');
        email.setPlainTextBody('Attached is the PDF of the quote.');
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('Quote.pdf');
        attachment.setBody(Page.ATEQ_Quote_Template.getContentAsPDF());
        email.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        return null;
    }
}
<%@ Import Namespace="System" %>
<%@ Import Namespace="Sitecore.Analytics.Data" %>
<%@ Import Namespace="Sitecore.Analytics.Outcome" %>
<%@ Import Namespace="Sitecore.Analytics.Outcome.Model" %>
<%@ Import Namespace="Sitecore.Analytics.Tracking" %>
<%@ Import Namespace="Sitecore.Configuration" %>
<%@ Import Namespace="Sitecore.Data" %>

<%@ Language="C#" %>
<script runat="server" language="C#">
    void Page_Load(object sender, System.EventArgs e)
    {
        //Get contact based on email address
        //Currently hard-coded for a contact with the email "rc@gmail.com"
        ContactRepository repo = Factory.CreateObject("tracking/contactRepository", true) as ContactRepository;
        Contact contact = repo.LoadContactReadOnly(@"crm\rc@gmail.com") as Contact;

        //Register an outcome against the contact
        if (contact != null)
        {
            Response.Write(contact.ContactId.ToString());

            Sitecore.Data.ID outcomeId = Sitecore.Data.ID.NewID;
            Sitecore.Data.ID outcomeDefinitionId = Sitecore.Data.ID.Parse("{C2D9DFBC-E465-45FD-BA21-0A06EBE942D6}");
            Sitecore.Data.ID interactionId = Sitecore.Data.ID.NewID;
            Sitecore.Data.ID contactId = Sitecore.Data.ID.Parse(contact.ContactId);

            var manager = Factory.CreateObject("outcome/outcomeManager", true) as OutcomeManager;
            var outcome = new ContactOutcome(outcomeId, outcomeDefinitionId, contactId)
            {
                InteractionId = interactionId,
                DateTime = DateTime.Now,
                MonetaryValue = 10
            };
            manager.Save(outcome);
        }
    }
</script> 
<!DOCTYPE html>
<html>
  <head>
    <title>CRM Outcome Registered</title>
  </head>
  <body>
    <h1>CRM Outcome Registered !!</h1>
  </body>
</html>
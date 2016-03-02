<%@ Page language="c#" %>
<script runat="server">
  void Page_Load(object sender, System.EventArgs e) {
      Session.Abandon();
  }
</script> 
<!DOCTYPE html>
<html>
  <head>
    <title>Session Abandon</title>
  </head>
  <body>
    <h1>Session Abandoned !! </h1>
  </body>
</html>
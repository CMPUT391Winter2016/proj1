<%
session.removeAttribute("userName");
response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "home.html");

%>
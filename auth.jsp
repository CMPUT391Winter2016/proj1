<%
	session.setAttribute("dbname", request.getParameter("dbname"));
	session.setAttribute("dbpassword", request.getParameter("dbpassword"));
	session.setAttribute("dbdriver", request.getParameter("dbdriver"));
	session.setAttribute("dbstring", request.getParameter("dbstring"));
%>

<%=session.getAttribute("dbname")%>
<%=session.getAttribute("dbpassword")%>
<%=session.getAttribute("dbdriver")%>
<%=session.getAttribute("dbstring")%>

<%
response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "home.html");
%>
<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%! String owner; %>
<%
if(session.getAttribute("userName") == null){
   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "home.html");
} else{
String photo_id = request.getQueryString();
String query = "SELECT first_name FROM persons WHERE user_name = '"+session.getAttribute("userName")+"'";

String DBdriver = session.getAttribute("dbdriver").toString();
String DBname = session.getAttribute("dbname").toString();
String DBpw = session.getAttribute("dbpassword").toString();
String DBstring = session.getAttribute("dbstring").toString();
Connection conn = null;

try{ 
//load and register the driver 
Class drvClass = Class.forName(DBdriver);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

 try{ 
//establish the connection 
conn = DriverManager.getConnection(DBstring,DBname,DBpw);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

try {
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    rset.next();
	    owner = rset.getString("first_name");

%>

<!-- //Small landing page if you are a valid user. -->
<html>
<head>
<title> <%=owner%>'s Site
</title>
</head>
<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%">put header here</td>
</tr>

<tr bgcolor="#FFFFFF">

<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> | <a href="logout.jsp">Logout</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>

<h1>Hello <%=owner%></h1>
<h2>Top Five Most Viewed</h2>
<%

	   
	    ResultSet rst = stmt.executeQuery("SELECT * FROM (SELECT photo_id, DENSE_RANK() OVER(order by views desc) as rank FROM popularity) where rank < 6");
	    int count = 0;
	    out.println("<table border='1px'>");
	    while(rst.next()){
		if ( count % 5 == 0) out.println("<tr>");
		out.println("<td><a href='viewpicture.jsp?"+rst.getInt("photo_id")+"'><img src='GetThumbnail.jsp?"+rst.getInt("photo_id")+"'/></a></td>");
		count++;
	    }
	    
} catch( Exception ex ) {
	    out.println(ex.getMessage() );
	}
	// to close the connection
	finally {
	    try {
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
}
%>


<br>

</td>
</tr>

</table>

</body>
</html>

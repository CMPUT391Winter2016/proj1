<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%! String owner, subject, place, description; %>
<%
String photo_id = request.getQueryString();
String query = "SELECT owner_name, subject, timing, place, description FROM images WHERE photo_id = "+photo_id;

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
	    owner = rset.getString("owner_name");
	    subject = rset.getString("subject");
	    place = rset.getString("place");
	    description = rset.getString("description");
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

%>

<html>
<head>
<title>Viewing Photo <%=photo_id%></title>
</head>


<body>

<img src="GetPicture.jsp?<%=photo_id%>"/>
<table>
<tr>
<td>Owner:</td>
<td><%=owner%></td>
<tr>
<td>Subject:</td>
<td><%=subject%></td>
<tr>
<td>Place:</td>
<td><%=place%></td>
<tr>
<td>Description:</td>
<td><%=description%></td>
</table>

<table>
<tr>
<td><a href="PictureBrowse.jsp">Back</a>
</body>

</html>
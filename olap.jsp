<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%

String driverName = session.getAttribute("dbdriver").toString();
String dbname = session.getAttribute("dbname").toString();
String dbpassword = session.getAttribute("dbpassword").toString();
String dbstring = session.getAttribute("dbstring").toString();
Connection conn = null;


try{ 
//load and register the driver 
Class drvClass = Class.forName(driverName);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "broke");
	 }
 try{ 
//establish the connection 
conn = DriverManager.getConnection(dbstring,dbname, dbpassword);
conn.setAutoCommit(false);
 } catch(Exception ex){ out.println(dbstring + ex.getMessage() + dbname);
	 }

Statement stmt = null;
ResultSet rset = null;


try{ 
stmt = conn.createStatement();


} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

%>



<html>
<head>
<title> Results
</title>
</head>
<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%">put header here</td>
</tr>

<tr bgcolor="#FFFFFF">

<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> |

<a href="analysis.jsp">Analysis</a> | 

 <a href="logout.jsp">Logout</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>

<center><font size=6><b>OLAP Data Analysis</b></font>



<br>

</td>
</tr>

</table>

</body>
</html>
<% conn.close(); %>

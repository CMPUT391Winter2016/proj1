<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%
session.removeAttribute("user_option");
session.removeAttribute("subject_option");
session.removeAttribute("date_option");

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
//get all usernames
Statement stmt = null;
Statement stmt2 = null;
ResultSet rset = null;
ResultSet rset2 = null;
String usernames = "SELECT user_Name from users order by user_Name asc";
String subjects = "SELECT distinct subject from images order by subject asc";


try{ 
stmt = conn.createStatement();
stmt2 = conn.createStatement();
rset = stmt.executeQuery(usernames);
rset2 = stmt2.executeQuery(subjects);


} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }



%>
<html>
<head>
<title> Data Analysis
</title>
</head>
<body>

<html>
<head>
<title>Sign up!</title>
</head>
<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%" bgcolor = "#3c94c3" valign = "bottom"><font size ="40" font face = "courier"> <p align = "right"><font color="183a4e">Photo</font><font color="#FFFFFF">synthesis</p></font></td>
</tr>




<tr bgcolor="#FFFFFF">

<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> |

<a href="analysis.jsp">Analysis</a> | 

 <a href="logout.jsp">Logout</a> | <a href="help.jsp">Help</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>

<center><font size=6><b>OLAP Data Analysis</b></font>
<br>
Select the information to analyze.
<form method ="post" action="olap.jsp" name="make_olap">
<input type="checkbox" name="user_option" value="user_option">Users<br>
<input type="checkbox" name="subject_option" value="subject_option">Subject<br>
<input type="checkbox" name="date_option" value="date_option">Date Period<br>
<input type = "submit" value="Generate" name ="enter_olap"></input>
</form>
<p>

</td>
</tr>

</table>

</body>
</html>
<% conn.close(); %>

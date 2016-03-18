<%@ page import="java.sql.*" %> 

<%
//establish the connection to the underlying database
Connection conn = null;
String driverName = session.getAttribute("dbdriver").toString();
String dbstring = session.getAttribute("dbstring").toString();
String dbname = session.getAttribute("dbname").toString();
String dbpassword = session.getAttribute("dbpassword").toString();
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
//select the user table from the underlying db and validate the user name and password
Statement stmt = null;
ResultSet rset = null;
String username = session.getAttribute("userName").toString();
String sql = "select group_id,group_name from groups where user_name = '"+username+"'";

try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql);

} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

%> 

<html>
<head>
<title>Add Photo</title>
</head>

<body>

<form name="upload" method="post" action="upload.jsp" enctype="multipart/form-data">
<table>
<tr>
<td>Chose file name</td>
<td><input name="file-path" type="file" required multiple></td>
</tr>
<tr>
<td>Subject:</td>
<td><input name="subject" placeholder="Subject" type="text" required></td>
</tr>
<tr>
<td>Date:</td>
<td><input name = "date" type = "date" required></td>
</tr>
<tr>
<td>Visibility:</td>
<td>
<select name = "group">
  <option value="2">Private</option>
  <option value="1">Public</option>
  <%
     while(rset.next()){
     out.println("<option value='"+rset.getInt("group_id")+"'>"+rset.getString("group_name")+"</option>");
     }
     %>
</select>
</td>
<tr>
<td>Location:</td>
<td><input name = "location" placeholder = "Location" type =
	   "text"></td>
<tr>
<td>Description:</td>
<td><textarea name = "description" rows = "10" cols ="30"></textarea></td>
<tr>
<td> <input name="submit" type="submit"></td>
</table>
</form>

</body>
</html>

<% conn.close(); %>

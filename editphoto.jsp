<%@ page import="java.sql.*" %> 
<%! String subject, place, description, date;
    int permitted; %>
<%
   String photo_id = request.getQueryString();

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

String sql = "select subject, permitted, timing, place, description FROM images WHERE photo_id = "+photo_id;

try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql);
rset.next();
subject= rset.getString("subject");
place = rset.getString("place");
date = rset.getString("timing").substring(0,10);
if (rset.getString("description") == null) {
   description = "";
} else {
  description = rset.getString("description");
}
permitted = rset.getInt("permitted");
} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

%> 

<html>
<head>
<title>Edit Photo</title>
</head>

<body>
<img src="GetPicture.jsp?<%=photo_id%>">
<form name="upload" method="post" action="updatephoto.jsp?<%=photo_id%>">
<table>
<tr>
<td>Subject:</td>
<td><input name="subject" placeholder="Subject" value = "<%=subject%>" type="text" required></td>
</tr>
<tr>
<td>Date:</td>
<td><input name = "date" type = "date" value = "<%=date%>" required></td>
</tr>
<tr>
<td>Visibility:</td>
<td>
<select name = "group">
<% if(permitted == 2){
  out.println("<option value='2' selected>Private</option>");
  } else{
  out.println("<option value='2'>Private</option>");
  }
  if(permitted == 1){
  out.println("<option value='1' selected>Public</option>");
} else {
  out.println("<option value='1'>Public</option>");
}

     String username = session.getAttribute("userName").toString();
String sql2 = "select group_id,group_name from groups where user_name = '"+username+"'";
     try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql2);
while(rset.next()){
     if(rset.getInt("group_id") == permitted)
     {
     out.println("<option value='"+rset.getInt("group_id")+"' selected>"+rset.getString("group_name")+"</option>");
} else {
   out.println("<option value='"+rset.getInt("group_id")+"'>"+rset.getString("group_name")+"</option>");
}
}
} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }
     
     %>
</select>
</td>
<tr>
<td>Location:</td>
<td><input name = "location" value ="<%=place%>" placeholder = "Location" type =
	   "text"></td>
<tr>
<td>Description:</td>
<td><textarea name = "description" rows = "10" cols ="30"><%=description%></textarea></td>
<tr>
<td> <input name="submit" type="submit"></td>
</table>
</form>

<form method="post" action="deletephoto.jsp?<%=photo_id%>">
<input type="submit" name='dsubmit' value="Delete">
</form>

</body>
</html>

<% conn.close(); %>

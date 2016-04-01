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

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%" bgcolor = "#3c94c3" valign = "bottom"><font size ="40" font face = "courier"> <p align = "right"><font color="183a4e">Photo</font><font color="#FFFFFF">synthesis</p></font></td>
</tr>

<tr bgcolor="#FFFFFF">


<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> |
<%
if(session.getAttribute("userName").toString().equals("admin")){
out.println("<a href=\"analysis.jsp\">Analysis</a> | ");
}
%>
<a href="logout.jsp">Logout</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>

<script type="text/javascript">

/*
Code for creating a calender in javascript for date selection, if browser doesn't support HTML5: JavascriptKit: http://www.javascriptkit.com/javatutors/createelementcheck2.shtml

Changing a javascript date picker into yyyy-mm-dd format: StackOverFlow user Pete Naylor: http://stackoverflow.com/questions/16025441/jquery-datepicker-change-date-format-to-yyyy-mm-dd-php


*/
    var datefield=document.createElement("input")
    datefield.setAttribute("type", "date")
    if (datefield.type!="date"){ //if browser doesn't support input type="date", load files for jQuery UI Date Picker
        document.write('<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />\n')
        document.write('<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"><\/script>\n')
        document.write('<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"><\/script>\n') 
    }
</script>
 
<script>
if (datefield.type!="date"){ //if browser doesn't support input type="date", initialize date picker widget:
    jQuery(function($){ //on document.ready
        //$('#date1').datepicker();
	

    })
}

$(function(){
    $("#date").datepicker({ dateFormat: 'yy-mm-dd' });
    $("#date").datepicker({ dateFormat: 'yy-mm-dd' }).bind("change",function(){
        var minValue = $(this).val();
        minValue = $.datepicker.parseDate("yy-mm-dd", minValue);
        minValue.setDate(minValue.getDate());
        
    })
});

</script>

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
<td><input name = "date" id = "date" type = "date" required></td>
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
	   "text" required></td>
<tr>
<td>Description:</td>
<td><textarea name = "description" rows = "10" cols ="30"></textarea></td>
<tr>
<td> <input name="submit" type="submit"></td>
</table>
</form>

</td>
</tr>

</table>


</body>
</html>

<% conn.close(); %>

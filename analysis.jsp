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
Select the information to analyze.
<form method ="post" action="olap.jsp" name="make_olap">
<br>
Usernames:<br>
<select size = "5">
<%
int i = 1;
while(rset.next()){
out.println("<option>" + i + ": " + rset.getString(1) +"</option>");
i++;
}
%>
</select>
<br>

Subjects:<br>
<select size = "5">
<%
int j = 1;
while(rset2.next()){
out.println("<option>" + j + ": " + rset2.getString(1) +"</option>");
j++;
}
%>
</select>
<br>

<%
/*
Code for creating a calender in javascript for date selection, if browser doesn't support HTML5: JavascriptKit:
http://www.javascriptkit.com/javatutors/createelementcheck2.shtml

Changing a javascript date picker into yyyy-mm-dd format: StackOverFlow user Pete Naylor:
http://stackoverflow.com/questions/16025441/jquery-datepicker-change-date-format-to-yyyy-mm-dd-php
*/
%>

<script type="text/javascript">
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
        $('#birthday').datepicker();
    })
}

$(function(){
        $("#to").datepicker({ dateFormat: 'yy-mm-dd' });
        $("#from").datepicker({ dateFormat: 'yy-mm-dd' }).bind("change",function(){
            var minValue = $(this).val();
            minValue = $.datepicker.parseDate("yy-mm-dd", minValue);
            minValue.setDate(minValue.getDate());
            $("#to").datepicker( "option", "minDate", minValue );
        })
    });
</script>

<br>
<center>
(optional)
From: 
<input type="date" id="from" name = "from" placeholder = "The Dawn of Time" />
To: 
<input type="date" id="to" name = "to" placeholder = "Now" />
<br>

<input type = "submit" value = "Generate" name = "enter_olap"></input>
</form>
<p>

</td>
</tr>

</table>

</body>
</html>
<% conn.close(); %>

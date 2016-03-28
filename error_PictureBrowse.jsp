<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<html>
<head>
<title>Picture Browse</title>
</head>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%" bgcolor = "#3c94c3" valign = "bottom"><font size ="40" font face = "courier"> <p align = "right"><font color="183a4e">Photo</font><font color="#FFFFFF">synthesis</p></font></td>
</tr>

<tr bgcolor="#FFFFFF">


<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> |
<a href="logout.jsp">Logout</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>





<%
String photo_id = request.getQueryString();

String query = "(SELECT i.photo_id from images i, groups g, group_lists l WHERE l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = g.group_id AND g.group_id = i.permitted) UNION (SELECT photo_id from images WHERE permitted = 1 OR owner_name = '"+session.getAttribute("userName")+"')";


//get database info from the session (auth.html)

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
   out.println("<body>");
   out.println("<table border='1px'>");
   int i = 0;
            while(rset.next())
            {
   if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("<p><a href='success.jsp'>Home</a></p>");
   out.println("</body>");
	    
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

<body>
<center>
<font color = red><b>Invalid search query. Please try again.</font></b>
<center><b>Search</b></center>


<center><form method ="post" action="search.jsp" name="searchform">
<input type = "text" placeholder = "Search" name = "search"></input>
<br>
Order by 
 <select id = "orderby" name="orderby">
  <option value="relevance">Relevance</option>
  <option value="recent">Recent</option>
  <option value="oldest">Oldest</option>
</select>

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

<input type = "submit" value = "Search" name = "enter_search"></input>
<p>


<br>


</form>

</body>




</td>
</tr>

</table>


</html>

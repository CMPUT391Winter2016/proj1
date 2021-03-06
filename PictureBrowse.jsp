<%@ page import="java.sql.* ,java.util.* , java.io.*" %> 

<html>
<head>
<title>Search Results</title>
</head>
<body>

<%
String username = session.getAttribute("userName").toString();


String date1 = "", date2="", search="", dropdown="";

if (request.getParameter("date1") != null){
   date1 = request.getParameter("date1").trim();
}
if (request.getParameter("date2") != null){
   date2 = request.getParameter("date2").trim();
}
if (request.getParameter("search") != null){
   search = request.getParameter("search");
}
if (request.getParameter("orderby") != null){
   dropdown = request.getParameter("orderby");
}

%>




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
<a href="logout.jsp">Logout</a> | <a href="help.jsp">Help</a> ||</td>

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
	//$('#date2').datepicker();

    })
}

$(function(){
    $("#date1").datepicker({ dateFormat: 'yy-mm-dd' });
    $("#date2").datepicker({ dateFormat: 'yy-mm-dd' }).bind("change",function(){
        var minValue = $(this).val();
        minValue = $.datepicker.parseDate("yy-mm-dd", minValue);
        minValue.setDate(minValue.getDate());
        //$("#date1").datepicker( "option", "minDate", minValue );
    })
});

</script>


<table border='1px'>
<form action='PictureBrowse.jsp' method='post' name='searchform'>

<td>Search Terms
<td>Date Ranges
<td>Order By
<tr>
<%
out.println("<td><input type='test' placeholder='Search' name='search' value='"+search+"'>");
out.println("<td><input type='date' id = 'date1' name='date1' value='"+date1+"'>-<input type='date' id = 'date2' name='date2' value='"+date2+"'>");
out.println("<td><select name='orderby'>");
if (dropdown.equals("recent") || dropdown.equals("")){
  out.println("<option value='recent' selected>Recent");
  out.println("<option value='oldest'>Oldest");
  out.println("<option value='relevance'>Relevance");
} else if (dropdown.equals("oldest")){
  out.println("<option value='recent'>Recent");
  out.println("<option value='oldest' selected>Oldest");
  out.println("<option value='relevance'>Relevance");
} else {
  out.println("<option value='recent'>Recent");
  out.println("<option value='oldest'>Oldest");
  out.println("<option value='relevance' selected>Relevance");
}
out.println("</select>");

%>
</table>
<input type='submit'>
</form>


<% 
//get databse driver information from session
String m_driverName = session.getAttribute("dbdriver").toString();
String m_userName = session.getAttribute("dbname").toString();
String m_password = session.getAttribute("dbpassword").toString();
String m_url = session.getAttribute("dbstring").toString();

String addItemError = "";
Connection conn;
String createString;
Statement stmt;
ResultSet rset;

try {
Class drvClass = Class.forName(m_driverName);
DriverManager.registerDriver((Driver) drvClass.newInstance());
conn = DriverManager.getConnection(m_url, m_userName, m_password);
} catch(Exception e) {
out.print("Error displaying data: ");
out.println(e.getMessage());
return; 
}






//Set the type of orderby
String orderby = "", groupby = "";
if (dropdown.equals("recent")){
   orderby = " ORDER BY timing desc";
   groupby = ", i.timing ";
} else if (dropdown.equals("oldest")){
  orderby = " ORDER BY timing asc";
  groupby = ", i.timing ";
} else if (dropdown.equals("relevance") && !search.equals("")) {
  String[] terms = search.split(" ");
  String orderby6 = "", orderby3 = "", orderby1 = "";
  for (int i = 0; i < terms.length*3; i=i+3){
      if (orderby6.equals("")){
      	 orderby6 = orderby6 + "score("+(i+1)+")";
      } else {
      	orderby6 = orderby6 + " + score("+(i+1)+")";
      }	 
      if (orderby3.equals("")){
      	 orderby3 = orderby3 + "score("+(i+2)+")";
      } else {
      	orderby3 = orderby3 + " + score("+(i+2)+")";
      }
      if (orderby1.equals("")){
      	 orderby1 = orderby1 + "score("+(i+3)+")";
      } else {
      	orderby1 = orderby1 + " + score("+(i+3)+")";
      }
      groupby = groupby + ", score("+(i+1)+"), score("+(i+2)+"), score("+(i+3)+")";
  }
  orderby = " ORDER BY 6*("+orderby6+") +  3*("+orderby3+") + ("+orderby1+")";
}


//The different kinds of input the user can give
String query = "";
if (!search.equals("")){
   String[] terms = search.split(" ");
   String contains = "";
   for (int i = 0; i < terms.length*3; i=i+3){
       contains = contains + "AND (contains(subject, '"+terms[i/3]+"', "+(i+1)+")>0 OR contains(place, '"+terms[i/3]+"', "+(i+2)+")>0 OR contains(description, '"+terms[i/3]+"', "+(i+3)+")>0 ) ";
     }
   if (!date1.equals("") && !date2.equals("")){
     if(username.equals("admin")){
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id WHERE "+
       	       "timing between to_date('"+date1+"', 'yyyy-mm-dd') AND to_date('"+date2+"', 'yyyy-mm-dd')"+contains+" GROUP BY i.photo_id" + groupby + orderby;
     } else {
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id " +
      	      "WHERE (l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing between to_date('"+date1+"', 'yyyy-mm-dd') AND to_date('"+date2+"', 'yyyy-mm-dd')"
	      +contains+" GROUP BY i.photo_id" +groupby+ orderby;
     }
   } else if (!date1.equals("")){
     if(username.equals("admin")){
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id WHERE "+
       	       "timing >= to_date('"+date1+"', 'yyyy-mm-dd')"+contains+" GROUP BY i.photo_id"+groupby + orderby;
     } else {
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id " +
      	      "WHERE (l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd')"
	      +contains+" GROUP BY i.photo_id"+groupby+ orderby;
     }
   } else if (!date2.equals("")){
     if(username.equals("admin")){
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id WHERE "+
       	       "timing <= to_date('"+date2+"', 'yyyy-mm-dd')"+contains+" GROUP BY i.photo_id"+groupby+ orderby;
     } else {
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id " +
      	      "WHERE (l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing <= to_date('"+date2+"', 'yyyy-mm-dd')"
	      +contains+" GROUP BY i.photo_id"+groupby+ orderby;
     }
   } else {
     if(username.equals("admin")){
       //FIX
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id WHERE "+contains.substring(3)+ " GROUP BY i.photo_id" +groupby+ orderby;
     } else {
       query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id " +
      	      "WHERE (l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') "+contains+" GROUP BY i.photo_id" + groupby+ orderby;
     }

   }

} else {

  if (!date1.equals("") && !date2.equals("")){
     if (username.equals("admin")){
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "timing between to_date('"+date1+"', 'yyyy-mm-dd') AND to_date('"+date2+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby+ orderby;
    } else {
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "(l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing between to_date('"+date1+"', 'yyyy-mm-dd') AND "+
	    "to_date('"+date2+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby+ orderby;
    }
  } else if (!date1.equals("")){
    if (username.equals("admin")){
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "timing >= to_date('"+date1+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby + orderby;
    } else {
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "(l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby+ orderby;
    }
  } else if (!date2.equals("")){
    if (username.equals("admin")){
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "timing <= to_date('"+date2+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby+ orderby;
    } else {
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted=l.group_id WHERE " +
    	    "(l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') GROUP BY i.photo_id"+groupby+ orderby;
    }
  } else {

    if(username.equals("admin")){
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id GROUP BY i.photo_id"+groupby+ orderby;
    } else {
      query = "SELECT i.photo_id as photo_id FROM images i LEFT OUTER JOIN group_lists l ON i.permitted = l.group_id " +
      	      "WHERE (l.friend_id = '"+username+"' OR i.permitted = 1 OR i.owner_name = '"+username+"') GROUP BY i.photo_id"+groupby+ orderby;
    }
  }

}


try{ 
  stmt = conn.createStatement();
  rset = stmt.executeQuery(query);
  int i = 0;

  out.println("<table border='1px'>");  
  while (rset.next()){
  if (i%3==0) out.println("<tr>");
  out.println("<td><a href='viewpicture.jsp?"+rset.getInt(1)+"'><img src='GetThumbnail.jsp?"+rset.getInt(1)+"'/></a>");
  i++;
  }
  



} finally {conn.close();}





 %> 



</td>
</tr>

</table>


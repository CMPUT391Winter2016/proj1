<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%
if(request.getParameter("user_option") !=null){
   session.setAttribute("user_option", "true");
}
if(request.getParameter("subject_option") !=null){
   session.setAttribute("subject_option", "true");
}
if(request.getParameter("date_option") !=null){
   session.setAttribute("date_option", "true");
}

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
<table border='1px'>
<form>
<% 
if(session.getAttribute("user_option") != null){
	 out.println("<td>Users</td>");
}
if(session.getAttribute("subject_option") != null){
	 out.println("<td>Subject</td>");
}
if(session.getAttribute("date_option") != null){
	 out.println("<td>Date Period</td>");
}
out.println("<tr>");
if(session.getAttribute("user_option") != null){
	 out.println("<td><input type='text' name='owner' placeholder='User'/></td>");
}
if(session.getAttribute("subject_option") != null){
	 out.println("<td><input type='text' name='subject' placeholder='Subject'/></td>");
}
if(session.getAttribute("date_option") != null){
	 out.println("<td><input type='date' name='date1'/> - <input type='date' name='date2'>");
	 out.println("<br>");
	 out.println("<input type='radio' name='filter' value='year' checked>Yearly");
	 out.println("<input type='radio' name='filter' value='month'>Monthly");
	 out.println("<input type='radio' name='filter' value='week'>Weekly");
	 out.println("</td>");
}

%>
</table>
<input type='submit'>
<input type='submit' value='Restart' formaction='analysis.jsp'>

</form>
<center><h1>Report</h1>
<table border='1px'>
<%
String owner_option = "", subject_option ="", date_option="";
String owner = "", subject ="", date1 ="", date2 ="", filter="";
if (request.getParameter("owner") != null){
owner = request.getParameter("owner");
}
if (request.getParameter("subject") != null){
subject = request.getParameter("subject");
}
if (request.getParameter("date1") != null){
date1 = request.getParameter("date1");
}
if (request.getParameter("date2") != null){
date2 = request.getParameter("date2");
}
if (request.getParameter("filter") != null){
filter = request.getParameter("filter");
}
if(session.getAttribute("user_option") != null){
owner_option = session.getAttribute("user_option").toString();
}
if(session.getAttribute("subject_option") != null){
subject_option = session.getAttribute("subject_option").toString();
}
if(session.getAttribute("date_option") != null){
date_option = session.getAttribute("date_option").toString();
}

if(!owner_option.equals("")){
  out.println("<td>User</td>");
}
if(!subject_option.equals("")){
  out.println("<td>Subject</td>");
}
if(!date_option.equals("")){
  if(filter.equals("year") || filter.equals("")){
    out.println("<td>Year</td>");
  } else if (filter.equals("month")) {
    out.println("<td>Year</td>");
    out.println("<td>Month</td>");
  } else {
    out.println("<td>Year</td>");
    out.println("<td>Month</td>");
    out.println("<td>Week</td>");
    }
}
out.println("<td>Image Count</td>");
out.println("<tr>");


String query = "";
// If the user has chosen all 3 options
//
if(!owner_option.equals("") && !subject_option.equals("") && !date_option.equals("")){
  //Set the select and group by sections of query
  String select="", group="";
  if (filter.equals("year") || filter.equals("")) {
     select = "SELECT owner_name,subject,to_char(timing, 'yyyy') as year, sum(count) as count";
     group = "GROUP BY owner_name,subject, to_char(timing, 'yyyy')"; 
  } else if (filter.equals("month")){
     select = "SELECT owner_name,subject, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, sum(count) as count";
     group = "GROUP BY owner_name,subject, to_char(timing, 'yyyy'), to_char(timing, 'mm')";
  } else {
     select = "SELECT owner_name,subject, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, to_char(timing, 'ww') as week, sum(count) as count";
     group = "GROUP BY owner_name,subject, to_char(timing, 'yyyy'), to_char(timing, 'mm'), to_char(timing, 'ww')";
  } 
  //Create query for rest
  if(!owner.equals("")) {
     if(!subject.equals("")) {
       if (!date1.equals("") && !date2.equals("")) {
       	  query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject = '"+subject+"'" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date1.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject = '"+subject+"'" +
	  	  " AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date2.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject = '"+subject+"'" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
       } else {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject = '"+subject+"'" +
	  	  " AND timing is not null "+group;
       }
     } else {
       if (!date1.equals("") && !date2.equals("")) {
       	  query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject is not null" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date1.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject is not null" +
	  	  " AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date2.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject is not null" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
       } else {
       	 query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject is not null" +
	  	  " AND timing is not null "+group;
       }
    }
  } else {
    if(!subject.equals("")) {
       if (!date1.equals("") && !date2.equals("")) {
       	  query = select+" FROM image_cube WHERE owner_name is not null AND subject = '"+subject+"'" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date1.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject = '"+subject+"'" +
	  	  " AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date2.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject = '"+subject+"'" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
       } else {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject = '"+subject+"'" +
	  	  " AND timing is not null "+group;
       }
     } else {
       if (!date1.equals("") && !date2.equals("")) {
       	  query = select+" FROM image_cube WHERE owner_name is not null AND subject is not null" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date1.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject is not null" +
	  	  " AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
       } else if (!date2.equals("")) {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject is not null" +
	  	  " AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
       } else {
       	 query = select+" FROM image_cube WHERE owner_name is not null AND subject is not null" +
	  	  " AND timing is not null "+group;
       }
    }
}
//If the user has chosen user + subject
//
} else if (!owner_option.equals("") && !subject_option.equals("")) {
  if (!owner.equals("")){
     if (!subject.equals("")){
     	query = "SELECT owner_name, subject, count FROM image_cube WHERE owner_name = '"+owner+"' " + 
	      "AND subject = '"+subject+"' AND timing is null";
     } else {
       query = "SELECT owner_name, subject, count FROM image_cube WHERE owner_name ='"+owner+"' " +
       	     "AND subject is not null AND timing is null";
     }
  } else {
    if (!subject.equals("")){
       query = "SELECT owner_name, subject, count FROM image_cube WHERE owner_name is not null " + 
	      "AND subject = '"+subject+"' AND timing is null";
     } else {
       query = "SELECT owner_name, subject, count FROM image_cube WHERE owner_name is not null " + 
	      "AND subject is not null AND timing is null";
     }
  }
//If the user has chosen user + date
//
} else if (!owner_option.equals("") && !date_option.equals("")){

  //Set the select and group by sections of query
  String select="", group="";
  if (filter.equals("year") || filter.equals("")) {
     select = "SELECT owner_name, to_char(timing, 'yyyy') as year, sum(count) as count";
     group = "GROUP BY owner_name, to_char(timing, 'yyyy')"; 
  } else if (filter.equals("month")){
     select = "SELECT owner_name, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, sum(count) as count";
     group = "GROUP BY owner_name, to_char(timing, 'yyyy'), to_char(timing, 'mm')";
  } else {
     select = "SELECT owner_name, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, to_char(timing, 'ww') as week, sum(count) as count";
     group = "GROUP BY owner_name, to_char(timing, 'yyyy'), to_char(timing, 'mm'), to_char(timing, 'ww')";
  } 
  
  //Set the rest of the query
  if(!owner.equals("")) {
     if (!date1.equals("") && !date2.equals("")) {
     	query = select+" FROM image_cube WHERE owner_name ='"+owner+"' AND subject is null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date1.equals("")) {
       query = select+" FROM image_cube WHERE owner_name ='"+owner+"' AND subject is null" +
	      	" AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date2.equals("")) {
       query = select+" FROM image_cube WHERE owner_name ='"+owner+"' AND subject is null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
     } else {
       query = select+" FROM image_cube WHERE owner_name = '"+owner+"' AND subject is null AND timing is not null "+group;
     }
  } else {
      if (!date1.equals("") && !date2.equals("")) {
      	 query = select+" FROM image_cube WHERE owner_name is not null AND subject is null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date1.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is not null AND subject is null" +
	      	" AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date2.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is not null AND subject is null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
     } else {
       query = select+" FROM image_cube WHERE owner_name is not null AND subject is null AND timing is not null "+group;
     }
  }
//If the user has chosen subject + date
//
} else if (!subject_option.equals("") && !date_option.equals("")){

   //Set the select and group by sections of query
  String select="", group="";
  if (filter.equals("year") || filter.equals("")) {
     select = "SELECT subject, to_char(timing, 'yyyy') as year, sum(count) as count";
     group = "GROUP BY subject, to_char(timing, 'yyyy')"; 
  } else if (filter.equals("month")){
     select = "SELECT subject, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, sum(count) as count";
     group = "GROUP BY subject, to_char(timing, 'yyyy'), to_char(timing, 'mm')";
  } else {
     select = "SELECT subject, to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, to_char(timing, 'ww') as week, sum(count) as count";
     group = "GROUP BY subject, to_char(timing, 'yyyy'), to_char(timing, 'mm'), to_char(timing, 'ww')";
  } 
  
  //Set the rest of the query
  if(!subject.equals("")) {
     if (!date1.equals("") && !date2.equals("")) {
     	query = select+" FROM image_cube WHERE owner_name is null AND subject = '"+subject+"'" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date1.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is null AND subject ='"+subject+"'" +
	      	" AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date2.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is null AND subject ='"+subject+"'" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
     } else {
       query = select+" FROM image_cube WHERE owner_name is null AND subject ='"+subject+"' AND timing is not null "+group;
     }
  } else {
      if (!date1.equals("") && !date2.equals("")) {
      	 query = select+" FROM image_cube WHERE owner_name is null AND subject is not null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date1.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is null AND subject is not null" +
	      	" AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
     } else if (!date2.equals("")) {
       query = select+" FROM image_cube WHERE owner_name is null AND subject is not null" +
	      	" AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
     } else {
       query = select+" FROM image_cube WHERE owner_name is null AND subject is not null AND timing is not null "+group;
     }
  }
// If the user has chosen user
//
} else if(!owner_option.equals("")){
  if (!owner.equals("")){
     query="SELECT owner_name, count FROM image_cube WHERE owner_name = '"+owner+"' AND subject is null AND timing is null";
  } else {
    query="SELECT owner_name, count FROM image_cube WHERE owner_name is not null AND subject is null AND timing is null";
  }
//If the user has chosen subject
} else if (!subject_option.equals("")){
  if (!subject.equals("")){
     query="SELECT subject, count FROM image_cube WHERE owner_name is null AND subject ='"+subject+"' AND timing is null";
  } else {
    query="SELECT subject, count FROM image_cube WHERE owner_name is null AND subject is not null AND timing is null";
  }
//If the usr has chosen date
} else if (!date_option.equals("")){
  //Set the select and group by sections of query
  String select="", group="";
  if (filter.equals("year") || filter.equals("")) {
     select = "SELECT to_char(timing, 'yyyy') as year, sum(count) as count";
     group = "GROUP BY to_char(timing, 'yyyy')"; 
  } else if (filter.equals("month")){
     select = "SELECT to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, sum(count) as count";
     group = "GROUP BY to_char(timing, 'yyyy'), to_char(timing, 'mm')";
  } else {
     select = "SELECT to_char(timing, 'yyyy') as year, to_char(timing, 'mm') as month, to_char(timing, 'ww') as week, sum(count) as count";
     group = "GROUP BY to_char(timing, 'yyyy'), to_char(timing, 'mm'), to_char(timing, 'ww')";
  } 
  //Construct the rest of the query based off of date inputs
  if(!date1.equals("") && !date2.equals("")){
    query = select+" FROM image_cube WHERE owner_name is null AND subject is null AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') " +
    	    "AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
  } else if (!date1.equals("")) {
    query = select+" FROM image_cube WHERE owner_name is null AND subject is null AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') "+group;
  } else if (!date2.equals("")) {
    query = select+" FROM image_cube WHERE owner_name is null AND subject is null AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') "+group;
  } else {
    query = select+" FROM image_cube WHERE owner_name is null AND subject is null AND timing is not null "+group;
  }
  
}



out.println(query);

try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(query);
while(rset.next()){
if(session.getAttribute("user_option") != null){
  out.println("<td>"+rset.getString("owner_name"));
}
if(session.getAttribute("subject_option") != null){
  out.println("<td>"+rset.getString("subject"));
}
if(!date_option.equals("")){
  if(filter.equals("year") || filter.equals("")){
    out.println("<td>"+rset.getString("year"));
  } else if(filter.equals("month")){
    out.println("<td>"+rset.getString("year"));
    out.println("<td>"+rset.getString("month"));
  } else {
    out.println("<td>"+rset.getString("year"));
    out.println("<td>"+rset.getString("month"));
    out.println("<td>"+rset.getString("week"));

  }

}
out.println("<td>"+rset.getString("count"));
out.println("<tr>");
}

} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }
%>


</body>
</html>
<% conn.close(); %>

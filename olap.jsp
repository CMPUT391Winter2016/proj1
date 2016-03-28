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
<input type='submit' value='Restart' formaction='analysis.jsp'>
<input type='submit'>
</form>
<center><h1>Report</h1>
<table border='1px'>
<%
String owner = request.getParameter("owner");
String subject = request.getParameter("subject");
String date1 = request.getParameter("date1");
String date2 = request.getParameter("date2");

if(session.getAttribute("user_option") != null){
  out.println("<td>User</td>");
}
if(session.getAttribute("subject_option") != null){
  out.println("<td>Subject</td>");
}
if(session.getAttribute("date_option") != null){
  out.println("<td>Date Period</td>");
}
out.println("<td>Image Count</td>");
out.println("<tr>");

String owner_string ="", subject_string = "", date_string="";
String and1 =" AND ", and2 =" AND ";
String where = "WHERE ", select = "owner_name, subject timing,count";

if(session.getAttribute("user_option") != null && session.getAttribute("subject_option") != null && session.getAttribute("date_option") !=null && owner == null && subject == null && date1 == null && date2 == null){
where = "";
}

if(session.getAttribute("user_option") != null){
   if(owner != null){
     owner_string = "owner_name = '"+owner+"'";
   } else {
     owner_string = "";
     and1 = "";
     }
} else {
  owner_string = "owner_name is NULL";
}

if(session.getAttribute("subject_option") != null){
   if(subject != null){
     subject_string = "subject = '"+subject+"'";
   } else {
     subject_string="";
     and2 = "";
     if(date1 == null && date2 == null && session.getAttribute("date_option") != null){
       and1="";
     }
     }
} else {
  subject_string = "subject is NULL";
}

if(session.getAttribute("date_option") != null){
  select = "owner_name, sum(count) as count";
  if(date1 != null && date2 != null){
  date_string = "timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND timing <= to_date('"+date2+"', 'yyyy-mm-dd')";
   } else if (date1 != null){
  date_string = "timing >= to_date('"+date1+"', 'yyyy-mm-dd')";
   } else if (date2 != null){
  date_string = "timing <= to_date('"+date2+"', 'yyyy-mm-dd')";
   } else {
     and2 = "";
   }
   if(request.getParameter("filter") == null){
      date_string = date_string + " AND owner_name is not null AND to_char(timing, 'yyyy') is not null GROUP BY to_char(timing, 'yyyy'), owner_name";
   }
} else {
  date_string = "timing is NULL";
}

String query = "SELECT "+select+" FROM image_cube "+where+owner_string+and1+subject_string+and2+date_string;
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
out.println("<td>"+rset.getString("count"));
out.println("<tr>");
}

} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }
%>


</body>
</html>
<% conn.close(); %>

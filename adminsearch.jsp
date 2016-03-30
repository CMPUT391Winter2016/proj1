<%@ page import="java.sql.* ,java.util.* , java.io.*" %> 

<html>
<head>
<title>Admin Search Results</title>
</head>
<body>




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
//a search page for admin's results. admin doesn't care about permissions.

//get databse driver information from session
String m_driverName = session.getAttribute("dbdriver").toString();
String m_userName = session.getAttribute("dbname").toString();
String m_password = session.getAttribute("dbpassword").toString();
String m_url = session.getAttribute("dbstring").toString();

String addItemError = "";
Connection m_con;
String createString;
Statement stmt;
ResultSet rset;

try {
Class drvClass = Class.forName(m_driverName);
DriverManager.registerDriver((Driver) drvClass.newInstance());
m_con = DriverManager.getConnection(m_url, m_userName, m_password);
} catch(Exception e) {
out.print("Error displaying data: ");
out.println(e.getMessage());
return; 
}

try {  

if (request.getParameter("enter_search") != null) { 
out.println("");
 out.println("Query is " + request.getParameter("search"));
 out.println("");

String[] dropdown = request.getParameterValues("orderby");
out.println("your choice was... " + dropdown[0]);

//out.println("<br>Your first date was... " +request.getParameter("from").trim());

String date1 = request.getParameter("from").trim();
String date2 = request.getParameter("to").trim();



//user chooses to search with no keyword, first date only, by relevance - not allowed as this doesnt make sense
//user chooses to search with no keyword, second date only, by relevance - not allowed as this doesnt make sense
//user chooses to search with no keyword, both dates, by relevance - not allowed as this doesnt make sense
//this covers each of those cases:
if( request.getParameter("search").equals("") && dropdown[0].equals("relevance") && date2.equals("") && date1.equals("") ) {
 response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_PictureBrowse.jsp");
}


//user chooses to search with no keyword, first date only, by oldest
else if( request.getParameter("search").equals("") && dropdown[0].equals("oldest") && date2.equals("") && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing >= to_date('"+date1+"', 'yyyy-mm-dd') )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }




//user chooses to search with no keyword, second date only, by oldest
else if( request.getParameter("search").equals("") && dropdown[0].equals("oldest") && date1.equals("") && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search with no keyword, both dates, by oldest
else if( request.getParameter("search").equals("") && dropdown[0].equals("oldest") && (!date1.equals("")) && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd'))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search with no keyword, first date only, by newest
else if( request.getParameter("search").equals("") && dropdown[0].equals("recent") && date2.equals("") && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing >= to_date('"+date1+"', 'yyyy-mm-dd') )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search with no keyword, second date only, by newest
else if( request.getParameter("search").equals("") && dropdown[0].equals("recent") && date1.equals("") && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search with no keyword, both dates, by newest
else if( request.getParameter("search").equals("") && dropdown[0].equals("recent") && (!date1.equals("")) && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd')) )";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd'))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search by relevance, first date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && date2.equals("") && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE  timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by 6*score2 + 3*score3 + score1 desc");


 //PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE (permitted = 1 AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') )AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0  OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ) order by 6*score(2) + 3*score(3) + score(1) desc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }



//user chooses to search by relevance, second date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && date1.equals("") && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE  timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by 6*score2 + 3*score3 + score1 desc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search by relevance, both dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && (!date1.equals("")) && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE  timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by 6*score2 + 3*score3 + score1 desc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search by oldest, first date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("oldest") && date2.equals("") && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }



//user chooses to search by oldest, second date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("oldest") && date1.equals("") && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }




//user chooses to search by oldest, both dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("oldest") && (!date1.equals("")) && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//user chooses to search by newest, first date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("recent") && date2.equals("") && (!date1.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }



//user chooses to search by newest, second date only
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("recent") && date1.equals("") && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }




//user chooses to search by newest, both dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("recent") && (!date1.equals("")) && (!date2.equals("")) ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE timing <= to_date('"+date2+"', 'yyyy-mm-dd') AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");



rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }



//search is blank, no dates selected, by oldest
else if( (request.getParameter("search").equals("")) && dropdown[0].equals("oldest") && date1.equals("") && date2.equals("") ) {

//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted))";

String test2 = "(SELECT photo_id, timing FROM images )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }


//search is blank, no dates select, by newest
else if( (request.getParameter("search").equals("")) && dropdown[0].equals("recent") && date1.equals("") && date2.equals("") ) {


//String test = "(SELECT i.photo_id, i.timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted))";

String test2 = "(SELECT photo_id, timing FROM images )";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");


rset = doSearch.executeQuery();
out.println("<center>");

	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 }



//user chooses to search by relevance, no dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && date1.equals("") && date2.equals("") ) {


//String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE  ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by 6*score2 + 3*score3 + score1 desc");



rset = doSearch.executeQuery();
out.println("<center>");


	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 } //user searches by most recent, no dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("recent") && date1.equals("") && date2.equals("")) {



//String test = "(SELECT i.photo_id as photo_id, i.timing as timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing desc");

// PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE permitted = 1 AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ) order by timing desc");

rset = doSearch.executeQuery();


	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");





}

//user searches by oldest, no dates
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("oldest") && date1.equals("") && date2.equals("")) {


//String test = "(SELECT i.photo_id as photo_id, i.timing as timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" + test2 + ") order by timing asc");

// PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE permitted = 1 AND   ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ) order by timing asc");

rset = doSearch.executeQuery();


	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='viewpicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");





}
 } else { 
out.println("Please enter text for quering");
 } m_con.close();
 } catch(SQLException e) { 
out.println("error here: ");
out.println("SQLException: " + e.getMessage());
e.printStackTrace(System.out);
m_con.setAutoCommit(false);
 m_con.rollback();
m_con.setAutoCommit(true); }


//for reference, all of the cases:
//user chooses to search with no keyword, first date only, by relevance - not allowed as this doesnt make sense
//user chooses to search with no keyword, second date only, by relevance - not allowed as this doesnt make sense
//user chooses to search with no keyword, both dates, by relevance - not allowed as this doesnt make sense

//user chooses to search with no keyword, first date only, by oldest
//user chooses to search with no keyword, second date only, by oldest
//user chooses to search with no keyword, both dates, by oldest

//user chooses to search with no keyword, first date only, by newest
//user chooses to search with no keyword, second date only, by newest
//user chooses to search with no keyword, both dates, by newest

//user chooses to search by relevance, first date only
//user chooses to search by relevance, second date only
//user chooses to search by relevance, both dates

//user chooses to search by oldest, first date only
//user chooses to search by oldest, second date only
//user chooses to search by oldest, both dates

//user chooses to search by newest, first date only
//user chooses to search by newest, second date only
//user chooses to search by newest, both dates

//?search is blank, no dates selected, by oldest
//?search is blank, no dates select, by newest

//user chooses to search by relevance, no dates
//user searches by most recent, no dates
//user searches by oldest, no dates

 %> 



</td>
</tr>

</table>


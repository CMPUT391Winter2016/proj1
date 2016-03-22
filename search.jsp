<%@ page import="java.sql.* ,java.util.* , java.io.*" %> 

<% 
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

out.println("<br>Your first date was... " +request.getParameter("from"));

String date1 = request.getParameter("from");
String date2 = request.getParameter("to");



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
if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && date2.equals("") ) {

String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted AND i.timing >= to_date('"+date1+"', 'yyyy-mm-dd'))  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE (owner_name = '"+session.getAttribute("userName")+"' OR permitted = 1) AND timing >= to_date('"+date1+"', 'yyyy-mm-dd') AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" +test + " UNION " + test2 + ") order by 6*score2 + 3*score3 + score1 desc");


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
//user chooses to search by relevance, both dates

//user chooses to search by oldest, first date only
//user chooses to search by oldest, second date only
//user chooses to search by oldest, both dates

//user chooses to search by newest, first date only
//user chooses to search by newest, second date only
//user chooses to search by newest, both dates






//user chooses to search by relevance, no dates
 if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") && date1.equals("") && date2.equals("") ) {

String test = "(SELECT i.photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, score(1) as score1, score(2) as score2, score(3) as score3 FROM images WHERE owner_name = '"+session.getAttribute("userName")+"' OR permitted = 1 AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" +test + " UNION " + test2 + ") order by 6*score2 + 3*score3 + score1 desc");



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

String test = "(SELECT i.photo_id as photo_id, i.timing as timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE owner_name = '"+session.getAttribute("userName")+"' OR permitted = 1 AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" +test + " UNION " + test2 + ") order by timing desc");

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

String test = "(SELECT i.photo_id as photo_id, i.timing as timing FROM images i, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = i.permitted)  AND ( contains(i.description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(i.subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(i.place,'" +request.getParameter("search")+ "', 3) > 0 ))";

String test2 = "(SELECT photo_id, timing FROM images WHERE owner_name = '"+session.getAttribute("userName")+"' OR permitted = 1 AND ( contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 ))";

 PreparedStatement doSearch = m_con.prepareStatement("SELECT * FROM (" +test + " UNION " + test2 + ") order by timing asc");

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
m_con.setAutoCommit(true); } %> 


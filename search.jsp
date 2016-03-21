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
out.print("!!Error displaying data: ");
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

//user chooses to search by relevance
 if( (!request.getParameter("search").equals("")) && dropdown[0].equals("relevance") ) {
 PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 order by 6*score(2) + 3*score(3) + score(1) desc");


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

 } //user searches by most recent
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("recent") ) {
 PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 order by timing desc");

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

//user searches by oldest
else if( (!request.getParameter("search").equals("")) && dropdown[0].equals("oldest") ) {
 PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 order by timing asc");

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


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

 if(!(request.getParameter("search").equals(""))) {
 PreparedStatement doSearch = m_con.prepareStatement("SELECT photo_id FROM images WHERE contains(description,'" +request.getParameter("search")+ "', 1) > 0 OR contains(subject,'" +request.getParameter("search")+ "', 2) > 0 OR contains(place,'" +request.getParameter("search")+ "', 3) > 0 order by 6*score(2) + 3*score(3) + score(1) desc");

//doSearch.setString(6, request.getParameter("search"));
ResultSet rset = doSearch.executeQuery();


	out.println("<body>");
  	out.println("<table border='1px'>");
	int i = 0;

while(rset.next()) {

 if (i%3==0)
   {
   out.println("<tr>");
   }
   out.println("<td><a href='GetPicture.jsp?"+(rset.getObject(1)).toString()+"'>");
   out.println("<img src='GetThumbnail.jsp?"+(rset.getObject(1)).toString()+"'/></a>");
   i++;
            }
   out.println("</table>");
   out.println("</body>");

 } 



out.println("");
 //out.println(rset.getString(2));
 out.println("	");
 //out.println(rset.getString(3));
 out.println("	");
 //out.println(rset.getObject(1));
 out.println("");

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


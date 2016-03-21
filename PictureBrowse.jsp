<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%
String photo_id = request.getQueryString();
String query = "SELECT unique i.photo_id from images i, groups g, group_lists l WHERE (l.friend_id = '"+session.getAttribute("userName")+"' AND l.group_id = g.group_id AND g.group_id = i.permitted) OR i.permitted = 1 OR i.owner_name = '"+session.getAttribute("userName")+"'";

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

<input type = "submit" value = "Search" name = "enter_search"></input>
</form>

</body>

<html>
<head>
<title>Picture Browse</title>
</head>


</html>

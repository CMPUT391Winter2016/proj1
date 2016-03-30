<%@ page import="java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*, java.sql.Date" %>
<%! String owner, subject, place, description, date;
    int views;
    boolean allowed; %>
<%


//check to see if the user is an admin
boolean isAdmin = false;
if(session.getAttribute("userName").equals("admin")){
isAdmin=true;
}

//Is the user logged in, if not redirect to login
if (session.getAttribute("userName") == null)
{
 response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "home.html");
}
allowed = true;
String photo_id = request.getQueryString();
String query = "SELECT owner_name, subject, timing, place, description FROM images WHERE photo_id = "+photo_id;

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

//Check to see if the user should be able to see the picture
 try{ 
//establish the connection 
conn = DriverManager.getConnection(DBstring,DBname,DBpw);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
try{
	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery("SELECT * FROM ((SELECT photo_id FROM images WHERE permitted = 1 OR owner_name = '"+session.getAttribute("userName")+"') UNION (SELECT i.photo_id as photo_id FROM images i, group_lists l WHERE i.permitted = l.group_id AND l.friend_id = '"+session.getAttribute("userName")+"')) WHERE photo_id = "+photo_id);
        if (rset.next() == false){
	allowed = false;
}
} catch( Exception ex) {}

//If the user is allowed to see the picture, display with details
if(allowed||isAdmin){
try {
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    rset.next();
	    owner = rset.getString("owner_name");
	    subject = rset.getString("subject");
	    place = rset.getString("place");
	    if (rset.getString("description") == null){
	       description = "No description";
	       } else {
	       	 description = rset.getString("description");
		 }
	    date = rset.getString("timing");
	    rset = stmt.executeQuery("SELECT * from viewed WHERE photo_id = "+photo_id+" AND viewee = '"+session.getAttribute("userName")+"'");
	    if(!rset.next()){
		stmt.execute("INSERT INTO viewed values("+photo_id+", '"+session.getAttribute("userName")+"')");
		}
	    //stmt.executeUpdate("UPDATE popularity SET views = views + 1 WHERE photo_id = "+photo_id);
	    //rset = stmt.executeQuery("SELECT views FROM popularity WHERE photo_id = "+photo_id);
	    //rset.next();
	    //views = rset.getInt("views");
	    
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

out.println("<html>");
out.println("<head>");
out.println("<title>Viewing Photo "+photo_id+"</title>");
out.println("</head>");

out.println("<body>");

out.println("<img src='GetPicture.jsp?"+photo_id+"'/>");
out.println("<table>");
out.println("<tr>");
out.println("<td>Owner:</td>");
out.println("<td>"+owner+"</td>");
out.println("<tr>");
out.println("<td>Subject:</td>");
out.println("<td>"+subject+"</td>");
out.println("<tr>");
out.println("<td>Place:</td>");
out.println("<td>"+place+"</td>");
out.println("<tr>");
out.println("<td>Time:</td>");
out.println("<td>"+date.substring(0,10)+"</td>");
out.println("<tr>");
out.println("<td>Description:</td>");
out.println("<td>"+description+"</td>");
out.println("<tr>");
//out.println("<td>Views:</td>");
//out.println("<td>"+views+"</td>");
out.println("</table>");

out.println("<table>");
out.println("<tr>");
out.println("<td><a href='PictureBrowse.jsp'>Back</a>");
//If the user is the ower allow the user to edit
   if(owner.equals(session.getAttribute("userName"))){
out.println("<td><a href='editphoto.jsp?"+photo_id+"'>Edit</a>");
}

out.println("</table>");
out.println("</body>");

out.println("</html>");

}
else{ 

out.println("<html>");
out.println("<head>");
out.println("<title>Viewing Error</title>");
out.println("</head>");

out.println("<body>");
out.println("<h1>You do not have permission to view this picture</h1>");
out.println("<td><a href='PictureBrowse.jsp'>Browse Pictures</a>");
out.println("<td><a href='success.jsp'>Home</a>");
out.println("</body>");
}

%>

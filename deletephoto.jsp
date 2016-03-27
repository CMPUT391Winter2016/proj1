<%@ page import="java.sql.*" %> 

<%
   String photo_id = request.getQueryString();

//establish the connection to the underlying database
Connection conn = null;
String driverName = session.getAttribute("dbdriver").toString();
String dbstring = session.getAttribute("dbstring").toString();
String dbname = session.getAttribute("dbname").toString();
String dbpassword = session.getAttribute("dbpassword").toString();
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
//select the user table from the underlying db and validate the user name and password
Statement stmt = null;
ResultSet rset = null;

String sql = "DELETE FROM images WHERE photo_id = "+photo_id;

try{ 
stmt = conn.createStatement();
stmt.executeQuery("DELETE FROM viewed WHERE photo_id = "+photo_id);
stmt.executeQuery(sql);


} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

%> 

<html>
<head>
<title>Edit Photo</title>
</head>


</html>

<% conn.close();
response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "PictureBrowse.jsp");
 %>

<%@ page import="java.sql.*" %> 
<% int valid = 0;
if(request.getParameter("submit") != null) { 
//get the user input from the login page 
String userName = (request.getParameter("username")).trim();
String passwd = (request.getParameter("password")).trim();%>
<html>
<head> <title> Test </title> <head>
<body>
<p>Your username: <%= userName%> </p>
<p> Your password: <%= passwd%> </p> 

<%
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
String sql = "select password from users where user_name = '"+userName+"'";
out.println(sql);
try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql);
} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }
String truepwd = "";
while(rset != null && rset.next()) truepwd = rset.getString("password").trim();
//display the result 
out.println("<p>");

if(passwd.equals(truepwd))
{
 out.println("Your Login is Successful!"); 
 valid = 1;
}
else
{ 
  valid = 0;
  out.println("Either your userName or your password is invalid!");
}
out.println("</p>");
try{ conn.close();
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
	 } else {
out.println("null!!");
out.println("UserName:");
out.println("Password:");
out.println("");
out.println(""); } 

//Based on the input redirect to either an error home page or success
if (valid == 0)
{
   //response.setStatus(response.SC_MOVED_TEMPORARILY);
   //response.setHeader("Location", "error_home.html");
}
else
{
   String userName = (request.getParameter("username")).trim(); 
   session.setAttribute("userName", userName);
   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "success.jsp");
}

%> 

</body>
</html>
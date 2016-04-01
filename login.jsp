<%@ page import="java.sql.*" %> 

<html>
<head>
<title>Error - Welcome</title>
</head>
<body>


<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%" bgcolor = "#3c94c3" valign = "bottom"><font size ="40" font face = "courier"> <p align = "right"><font color="183a4e">Photo</font><font color="#FFFFFF">synthesis</p></font></td>
</tr>

<tr bgcolor="#FFFFFF">
<td>


<% int valid = 0;
if(request.getParameter("submit") != null) { 
//get the user input from the login page 
String userName = (request.getParameter("username")).trim();
String passwd = (request.getParameter("password")).trim();%>

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

try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql);
} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }
String truepwd = "";
while(rset != null && rset.next()) truepwd = rset.getString("password").trim();
//display the result 
//out.println("<p>");

if(passwd.equals("")||userName.equals("")){
valid = 0;
out.println("<font color = \"red\">Either your username or password is invalid, please try again!</font>");
}
else{
	if(passwd.equals(truepwd))
	{
	 out.println("Your Login is Successful!"); 
	 valid = 1;
	}
	else
	{ 
	  valid = 0;
	  out.println("<font color = \"red\">Either your username or password is invalid, please try again!</font>");
	}
}
//out.println("</p>");
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


<form method ="post" action="login.jsp" name="loginForm"> Sign in:
<br>
Username: <input type="text" placeholder = "Username" name="username"></input> 
<br>
Password: <input type="password" placeholder = "****" name="password"></input>
<br>
<input type = "submit" value = "Log in" name = "submit"></input>
</form>
<br>


<font size = "2"><i>Not a member? <a href = "sign_up.html">Sign up.</i></font></a>
</td>
</tr>

</table>

</body>
</html>


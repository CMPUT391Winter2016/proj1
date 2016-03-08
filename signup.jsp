<%@ page import="java.sql.*" %> 
<% if(request.getParameter("ssubmit") != null) { 
//get the user input from the login page 
String userName = (request.getParameter("username")).trim();
String passwd = (request.getParameter("password")).trim(); 
String fName = (request.getParameter("fname")).trim();
String lName = (request.getParameter("lname")).trim();
String address = (request.getParameter("address")).trim();
String email = (request.getParameter("email")).trim();
String phone = (request.getParameter("phone")).trim();
//remove unnecessary characters from phone so it doesn't crash oracle
//phone = phone.replaceAll("-","");
//phone = phone.replaceAll("(","");
//phone = phone.replaceAll(")","");
out.println("Your input User Name is "+userName+"<p>");
out.println("Your input password is "+passwd+"<p>");
//establish the connection to the underlying database
Connection conn = null;
String driverName = "oracle.jdbc.driver.OracleDriver";
String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
try{ 
//load and register the driver 
Class drvClass = Class.forName(driverName);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
 try{ 
//establish the connection 
conn = DriverManager.getConnection(dbstring,"nlovas","D4v3spr1t3");
conn.setAutoCommit(false);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
//select the user table from the underlying db, if username exists, give an error message
Statement stmt = null;
ResultSet rset = null;
ResultSet eRset = null;
String sql = "select user_name from users where user_name = '"+userName+"'";
//check to see if email is already in use
String email_check = "select user_name from persons where email='" +email+"'";
try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(sql);
} catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
/*
String truepwd = "";
while(rset != null && rset.next()) truepwd = (rset.getString(1)).trim();
*/
if(!rset.next()){ //if no matches, it's an unused username
out.println(userName+" is not currently in use.<p>");
	eRset = stmt.executeQuery(email_check);
	if(!eRset.next()){ //if their email is also not currently in use
		out.println(email+" is not currently in use");
		//store this username in the database
		String addstring = "insert into users values('" +userName+ "','" +passwd+ "', SYSDATE)";
		stmt.executeQuery(addstring);
		//store this person into the database
		String addstring2 = "insert into persons values('" +userName+
		"','" +fName+ "','" +lName+ "','" +address+ "','" +email+ "','" +phone+
		"')";
		stmt.executeQuery(addstring2);
		} else { //the email is already in use
			out.println(email+" is already in use.");
			}
	} else { //someone already is using this user name
	out.println("<p>Sorry, this username is already in use.");
	}
try{ conn.close();
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
	 } else {
out.println("null!!");
out.println("UserName:");
out.println("Password:");
out.println("");
out.println(""); } %> 
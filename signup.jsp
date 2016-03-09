<%@ page import="java.sql.* , java.io.*" %> 
<% if(request.getParameter("ssubmit") != null) { 
//get the user input from the signup page 
String userName = (request.getParameter("username")).trim().toLowerCase();
String passwd = (request.getParameter("password")).trim(); 

String fName = (request.getParameter("fname")).trim();
String lName = (request.getParameter("lname")).trim();
String address = (request.getParameter("address")).trim();
String email = (request.getParameter("email")).trim().toLowerCase();
String phone = (request.getParameter("phone")).trim();

phone=phone.replaceAll("\\D+",""); //remove unnecessary characters

//check to see if username, password, and email are not blank
if(userName.equals("") || passwd.equals("") || email.equals("")){
//redirect to page with an error message

   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_signup.html");

}

//check that the phone number is not too long
if(phone.length()>10){
//redirect to page with an error message

   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_phone_signup.html");

}


//establish the connection to the underlying database
Connection conn = null;

//get database info from the session (auth.html)

String DBdriver = session.getAttribute("dbdriver").toString();
String DBname = session.getAttribute("dbname").toString();
String DBpw = session.getAttribute("dbpassword").toString();
String DBstring = session.getAttribute("dbstring").toString();


try{ 
//load and register the driver 
Class drvClass = Class.forName(DBdriver);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }


 try{ 
//establish the connection 
//conn = DriverManager.getConnection(dbstring,"nlovas","D4v3spr1t3");
conn = DriverManager.getConnection(DBstring,DBname,DBpw);
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

boolean username_in_use=true;
boolean email_in_use=true;


if(!rset.next()){ //if no matches, it's an unused username
//out.println(userName+" is not currently in use.<p>");
username_in_use=false;

	eRset = stmt.executeQuery(email_check);

	if(!eRset.next()){ //if their email is also not currently in use
		//out.println(email+" is not currently in use");
		email_in_use = false;

		//store this username in the database
		String addstring = "insert into users values('" +userName+ "','" +passwd+ "', SYSDATE)";
		stmt.executeQuery(addstring);

		//store this person into the database
		String addstring2 = "insert into persons values('" +userName+
		"','" +fName+ "','" +lName+ "','" +address+ "','" +email+ "','" +phone+
		"')";
		stmt.executeQuery(addstring2);

		//set the session username
		session.setAttribute("userName", userName);
		

		} else { //the email is already in use
			//out.println(email+" is already in use.");
		response.setStatus(response.SC_MOVED_TEMPORARILY);
   		response.setHeader("Location", "error_in_use_signup.html");
			}

	} else { //someone already is using this user name
	response.setStatus(response.SC_MOVED_TEMPORARILY);
   	response.setHeader("Location", "error_in_use_signup.html");
	
	}

try{ conn.close();
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }
	 } else {
out.println("null!!");
out.println("UserName:");
out.println("Password:");
out.println("");
out.println(""); } 
%> 




<html>
<head>
<title>Sign up!</title>
</head>
<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%">put header here</td>
</tr>

<tr bgcolor="#FFFFFF">
<td>

Welcome, <%=session.getAttribute("userName")%>!

<br>

</td>
</tr>

</table>

</body>
</html>

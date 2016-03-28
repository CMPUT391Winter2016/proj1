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
String valid = "[a-zA-Z0-9]*";

//required fields cannot be blank
if(userName.equals("") || passwd.equals("") || email.equals("")){

  response.setStatus(response.SC_MOVED_TEMPORARILY);
  response.setHeader("Location", "error_signup.html");

}

//phone num cant be too long
else if(phone.length()>10){


   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_phone_signup.html");

}

//username can only contain letters and numbers

else if(!userName.matches(valid)){

response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_signup_badchar.html");

}
else {


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
		response.setStatus(response.SC_MOVED_TEMPORARILY);
  		response.setHeader("Location", "success.jsp");
		

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
	 }}
	 } else {
out.println("null!!");
out.println("UserName:");
out.println("Password:");
out.println("");
out.println(""); } 
%> 

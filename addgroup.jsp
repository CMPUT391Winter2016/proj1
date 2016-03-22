<%@ page import=" java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.* " %> 
<%! int group_id; %>
<% if(request.getParameter("agroup") != null) { 

//get the user input 
String userName = session.getAttribute("userName").toString();
String groupName = (request.getParameter("gname")).trim().toLowerCase(); 
session.setAttribute( "thegName", groupName );


//check to see if username, groupname are not blank
if(userName.equals("")){

   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_groups.html");

}
if(groupName.equals("") ){

   response.setStatus(response.SC_MOVED_TEMPORARILY);
   response.setHeader("Location", "error_groups.html");

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

conn = DriverManager.getConnection(DBstring,DBname,DBpw);
conn.setAutoCommit(false);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

//select the user table from the underlying db, if groupname exists under same username, give an error message

Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rset = null;
ResultSet rset2 = null;

//String group_check = "select group_name from groups where group_name='"+groupName+"' and user_name = '"+userName+"'";

try{ 
stmt = conn.createStatement();
stmt2 = conn.createStatement();
stmt3 = conn.createStatement();
rset = stmt.executeQuery("select group_name from groups where group_name='"+groupName+"' and user_name = '"+userName+"'");
rset2 = stmt2.executeQuery("SELECT group_id_sequence.nextval from dual");
rset2.next();



} catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

boolean groupname_in_use=true;

group_id = rset2.getInt(1);


//if no matches, it's an unused groupname
if(!rset.next()){ 
    
    groupname_in_use=false;
	
    //store group in the database
    String addstring = "insert into groups values('"+group_id+"' ,'" +userName+ "','" +groupName+ "', SYSDATE)";
    stmt3.executeQuery(addstring);

    //set the session username
    session.setAttribute("userName", userName);
    response.setStatus(response.SC_MOVED_TEMPORARILY);
    response.setHeader("Location", "success_groups.jsp");	

    } else { //the groupname under same user is already in use
      response.setStatus(response.SC_MOVED_TEMPORARILY);
      response.setHeader("Location", "error_groups.html");
    }


    try{ 
       conn.close();
       } catch(Exception ex){ out.println("" + ex.getMessage() + "");
}
	 }  



//rset.close();
//rset2.close();
//stmt.close();
//stmt2.close();
//stmt3.close();
//conn.close();


%> 


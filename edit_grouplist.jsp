<%@ page import=" java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.* " %> 

<html>
<head>
<title>edit group list</title>
</head>

<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%" bgcolor = "#3c94c3" valign = "bottom"><font size ="40" font face = "courier"> <p align = "right"><font color="183a4e">Photo</font><font color="#FFFFFF">synthesis</p></font></td>
</tr>

<tr bgcolor="#FFFFFF">


<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.jsp">Add Photo</a> | 

<a href="PictureBrowse.jsp">Search Photos</a> | <a href="groups.jsp">Groups</a> |
<a href="logout.jsp">Logout</a> ||</td>

</tr>

<tr bgcolor="#FFFFFF">
<td>




<font color = "green" size="4" > <%=session.getAttribute("GtoEdit")%> </font>
<form method ="get" action= "edit_group.jsp" name="editgroupForm"> 

<% 
int group_id;
if(request.getParameter("adduser") != null) {
Connection conn = null;

String DBdriver = session.getAttribute("dbdriver").toString();
String DBname = session.getAttribute("dbname").toString();
String DBpw = session.getAttribute("dbpassword").toString();
String DBstring = session.getAttribute("dbstring").toString();


try{ 
Class drvClass = Class.forName(DBdriver);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }


 try{ 
conn = DriverManager.getConnection(DBstring,DBname,DBpw);
conn.setAutoCommit(false);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rset = null;
ResultSet rset2 = null;
ResultSet rset3 = null;

String userName = session.getAttribute("userName").toString();
String groupUser = (request.getParameter("Username")).trim().toLowerCase(); 
String groupName = session.getAttribute("GtoEdit").toString();
String user_check = "select user_name from users where user_name='"+groupUser+"' ";
String groupId = "select group_id from groups where group_name ='"+groupName+"' AND user_name='"+userName+"'";



try{ 
stmt = conn.createStatement();
rset = stmt.executeQuery(user_check);
} catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

if(!rset.next()){ 
  out.println("no user with this name found");

}else{


   try{ 
     stmt2 = conn.createStatement();
     rset2 = stmt2.executeQuery(groupId);
     rset2.next();
     } catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }

        group_id= rset2.getInt(1);
        String user_check2 = "select friend_id from group_lists where friend_id='"+groupUser+"' and group_id="+group_id+" ";
        try{ 
          stmt3 = conn.createStatement();
          rset3 = stmt3.executeQuery(user_check2);
          } catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	  }

         if(rset3.next()){ 
            out.println("user already in the group");
         }else{

 
          String addstring = "insert into group_lists values("+group_id+" ,'" +groupUser+ "', SYSDATE, null)";
          stmt3 = conn.createStatement();        
          stmt3.executeUpdate(addstring);

          //response.setStatus(response.SC_MOVED_TEMPORARILY);
          //response.setHeader("Location", "groups.jsp");

        out.println("user "+ groupUser +" is successfully added to " +groupName + " group");
    }

}


conn.close();


}else{


if(request.getParameter("deluser") != null) {
Connection conn = null;

String DBdriver = session.getAttribute("dbdriver").toString();
String DBname = session.getAttribute("dbname").toString();
String DBpw = session.getAttribute("dbpassword").toString();
String DBstring = session.getAttribute("dbstring").toString();


try{ 
Class drvClass = Class.forName(DBdriver);
DriverManager.registerDriver((Driver) drvClass.newInstance());
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }


 try{ 
conn = DriverManager.getConnection(DBstring,DBname,DBpw);
//conn.setAutoCommit(false);
 } catch(Exception ex){ out.println("" + ex.getMessage() + "");
	 }

Statement stmt = null;
Statement stmt2 = null;
Statement stmt3 = null;
ResultSet rset = null;
ResultSet rset2 = null;
ResultSet rset3 = null;

String userName = session.getAttribute("userName").toString();
String groupUser = (request.getParameter("Username")).trim().toLowerCase(); 
String groupName = session.getAttribute("GtoEdit").toString();
String groupId = "select group_id from groups where group_name ='"+groupName+"' AND user_name='"+userName+"'";

   try{ 
     stmt2 = conn.createStatement();
     rset2 = stmt2.executeQuery(groupId);
     rset2.next();
     } catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	 }


group_id= rset2.getInt(1);
String user_check2 = "select friend_id from group_lists where friend_id='"+groupUser+"' and group_id="+group_id+" ";
     try{ 
       stmt3 = conn.createStatement();
       rset3 = stmt3.executeQuery(user_check2);
         } catch(Exception ex){ out.println("broke" + ex.getMessage() + "");
	  }

        if(!rset3.next()){ 
            out.println("user is already not in the group");
         }else{

 
          String addstring = "delete from group_lists where group_id="+group_id+" and friend_id= '"+groupUser+"' ";
          stmt3 = conn.createStatement();        
          stmt3.executeUpdate(addstring);

          //response.setStatus(response.SC_MOVED_TEMPORARILY);
          //response.setHeader("Location", "groups.jsp");
          out.println("user "+ groupUser +" is successfully deleted from " +groupName + " group");

    }




}
}

%>
<br>
<br>
<br>
<font size = "2"><i> <a href = "groups.jsp">Group Page</i></font></a>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>


</td>
</tr>

</table>
</body>
</html>

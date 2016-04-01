<%@ page import=" java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.* " %> 

<html>
<head>
<title> edit group </title>
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


<form method ="get" action= "edit_grouplist.jsp" name="editgroupForm"> 

<form method ="post" action= "edit_group.jsp" name="editgroupForm"> 
<form method ="post" action= "edit_grouplist.jsp" name="editgroupForm"> 
 
<br>
<br>

<font size = "4"><i>Edit the list of users in </i></font>
<font color = "green" size="4" > <%=request.getParameter("gname")%> </font>
<font size = "4"><i> group:</i></font>
<br>

<% if(request.getParameter("editgroup") != null)  { 
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
Statement statement = conn.createStatement();

String userName = session.getAttribute("userName").toString();
String groupName = (request.getParameter("gname")).trim().toLowerCase(); 
session.setAttribute( "GtoEdit", groupName );
Integer groupID;

ResultSet resultset = statement.executeQuery("select group_id from groups where group_name = '"+groupName+"' and user_name='"+userName+"'");
//check if the group name entered is vaild
if (!resultset.next()){
out.println("group name not found");

}else{

groupID=((Number) resultset.getObject(1)).intValue();
Statement statement2 = conn.createStatement();
ResultSet resultset2 = statement2.executeQuery("select friend_id from group_lists where group_id = '"+groupID+"'");
//to list the users in the group
if (!resultset2.next()){ //if no users added, print message and have the option to add users.
out.println("no users added to the group.");
 %>
<br>
<br>
write user name to add:
<br>
<input type="text" value = "" name="Username"></input>
<input type = "submit" value = "add user"  name = "adduser"></input>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>
<%
}else{//if there is users in the group, list them
 %>



        <TABLE BORDER="1">
            <TR>
                <TH><font size = "2"> List of users:</font></TH>
            </TR>
            <TD> <%= resultset2.getString("friend_id") %></td>
            <% while(resultset2.next()){ %>
            <TR>
                <TD> <%= resultset2.getString("friend_id") %></td>
            </TR>
            <% } %>
        </TABLE>

<br>
<br>
write user name to add/delete:
<br>
<input type="text" value = "" name="Username"></input>
<br>
<input type = "submit" value = "add user"  name = "adduser"></input>
<input type = "submit" value = "delete user"  name = "deluser"></input>
<br>
<br>
<font size = "2"><i> <a href = "groups.jsp">Group Page</i></font></a>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>

 <% } 

//resultset.close();
//resultset2.close();

%>
 <% } %>
</form>
</td>
</tr>
 <% 

//statement.close();
//conn.close();



} 


%>
 </td>
</tr>

</table>
</body>
</html>

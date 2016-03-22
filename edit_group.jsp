<%@ page import=" java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.* " %> 

<html>
<head>
<title> edit group </title>
</head>
<body>
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

if (!resultset.next()){
out.println("group name not found");



}else{

groupID=((Number) resultset.getObject(1)).intValue();
Statement statement2 = conn.createStatement();
ResultSet resultset2 = statement2.executeQuery("select friend_id from group_lists where group_id = '"+groupID+"'");

if (!resultset2.next()){
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
}else{
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
 
</body>
</html>

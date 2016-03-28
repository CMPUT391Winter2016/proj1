<%@ page import=" java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.* " %> 
<html>
<head>
<title>Groups</title>
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



<form method ="post" action= "edit_group.jsp" name="editgroupForm"> 
<form method ="get" action= "addgroup.jsp" name="editgroupForm">
<form method ="get" action= "add_groupuser.jsp" name="editgroupForm">
<form method ="get" action= "delete_groupuser.jsp" name="editgroupForm">


<font size = "4"><i>List of your groups:</i></font>
<br>
<%
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

ResultSet resultset = statement.executeQuery("select group_name from groups where user_name = '"+userName+"'");
if (!resultset.next()){
out.println("you don't have groups yet!");
}else{
 %>

        <TABLE BORDER="1">
            <TR>
                <TH><font color = "brown" >group name</font></TH>

            </TR>
            <TD> <%= resultset.getString("group_name") %></td>
            <% while(resultset.next()){ %>
            <TR>
                <TD> <%= resultset.getString("group_name") %></td>

            </TR>
            <% } %>
        </TABLE>
<br>
<font size = "2"><i>enter the group name you want to edit.</i></font>
<br>
<input type="text" value = "" name="gname"></input>
<input type = "submit" value = "edit"  name = "editgroup"></input>
  <% }


resultset.close();
statement.close();
conn.close();
 %>


<br>
<br>
<font size = "2"><i> <a href = "add_group.html">add group.</i></font></a>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>
<br>
<br>


</td>
</tr>

</table>


</body>
</html>

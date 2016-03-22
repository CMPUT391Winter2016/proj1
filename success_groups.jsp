<html>
<head>
<title> a new group</title>
</head>
<body>


<tr bgcolor="#FFFFFF">
<td>
<form method ="post" action= "addgroup.jsp" name="agroupForm"> 

<font size="3" > your new group </font>
<font color = "green" size="4" > <%=session.getAttribute("thegName")%> </font>
<font size="3" > is added </font>
<br>
<br>
<br>
<font size = "2"><i>add users to the group?.</i></font></a>
<br>
write user name to add:
<br>
<input type="text" value = "" name="Username"></input>
<input type = "submit" value = "add user"  name = "adduser"></input>
<br>
<font size = "2"><i> <a href = "add_group.html">Create another Group?</i></font></a>
<br>
<font size = "2"><i> <a href = "groups.jsp">Groups page</i></font></a>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>


</form>
</td>
</tr>
</body>
</html>

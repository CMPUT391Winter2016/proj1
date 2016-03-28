<html>
<head>
<title> a new group</title>
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


<tr bgcolor="#FFFFFF">
<td>
<form method ="post" action= "addgroup.jsp" name="agroupForm"> 

<font size="3" > your new group </font>
<font color = "green" size="4" > <%=session.getAttribute("thegName")%> </font>
<font size="3" > is added </font>
<br>
<br>
<br>
<br>
<font size = "2"><i> <a href = "add_group.html">Create another Group?</i></font></a>
<br>
<font size = "2"><i> <a href = "groups.jsp">Groups page</i></font></a>
<br>
<font size = "2"><i> <a href = "success.jsp">Home page.</i></font></a>


</form>


</td>
</tr>

</table>
</td>
</tr>
</body>
</html>

<!-- //Small landing page if you are a valid user. -->
<html>
<head>
<title> <%=session.getAttribute("userName")%>'s Site
</title>
</head>
<body>

<table border="1" width = "1650" height = "1000" cellpadding = "15" cellspacing = "10" bgcolor="#bedbeb">

<tr bgcolor="#FFFFFF">
<td height = "20%">put header here</td>
</tr>

<tr bgcolor="#FFFFFF">
<td height = "3%" cellpadding="30" cellspacing = "30">|| <a href="addphoto.html">Add Photo</a> | 
<a href="PictureBrowse.jsp">Search Photos</a> | Groups ||</td>
</tr>

<tr bgcolor="#FFFFFF">
<td>

<h1>Hello <%=session.getAttribute("userName")%></h1>
<p>What do you want to do now?<p>



<br>

</td>
</tr>

</table>

</body>
</html>

<!-- //Small landing page if you are a valid user. -->
<html>
<head>
<title> <%=session.getAttribute("userName")%>'s Site
</title>
</head>

<body>

<h1>Hello <%=session.getAttribute("userName")%></h1>
<p>What do you want to do now?<p>
<a href="addphoto.html">Add Photo</a>
<a href="">Search Photos</a>
</body>

</html>

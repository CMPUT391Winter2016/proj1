<html>
<head>
<title>Add Photo</title>
</head>

<body>

<form name="upload" method="post" action="upload.jsp" enctype="multipart/form-data">
<table>
<tr>
<td>Chose file name</td>
<td><input name="file-path" type="file" required multiple></td>
</tr>
<tr>
<td>Subject:</td>
<td><input name="subject" placeholder="Subject" type="text" required></td>
</tr>
<tr>
<td>Date:</td>
<td><input name = "date" type = "date" required></td>
</tr>
<tr>
<td>Location:</td>
<td><input name = "location" placeholder = "Location" type =
	   "text"></td>
<tr>
<td>Description:</td>
<td><textarea name = "description" rows = "10" cols ="30"></textarea></td>
<tr>
<td> <input name="submit" type="submit"></td>
</table>
</form>

</body>
</html>

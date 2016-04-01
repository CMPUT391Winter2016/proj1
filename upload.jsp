<html>
<head>
<title>Photo Upload</title>
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



<%@ page import="org.apache.commons.fileupload.DiskFileUpload, org.apache.commons.fileupload.FileItem, java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*, java.awt.Image, java.awt.image.BufferedImage, javax.imageio.ImageIO" %>
<%! int photo_id, group_id;
    String subject, location, description, date;
    //java.sql.Date date; %>
<%
DiskFileUpload fu = new DiskFileUpload();
List FileItems = fu.parseRequest(request);
Iterator i = FileItems.iterator();
FileItem temp = (FileItem) i.next();
List files  = new ArrayList();
while (i.hasNext())
{
	if(temp.isFormField()){
	if(temp.getFieldName().equals("subject"))
	{
	  subject = temp.getString();
	}
	else if (temp.getFieldName().equals("location"))
	{
	  location = temp.getString();
	}
	else if (temp.getFieldName().equals("description"))
	{
	  description = temp.getString();
	} else if (temp.getFieldName().equals("date"))
	{
	  date = temp.getString();
	  
	} else if(temp.getFieldName().equals("group"))
	{
	  group_id = Integer.parseInt(temp.getString());
	}
	}
	else
	{
	files.add(temp);
	
	}
	
	temp = (FileItem) i.next();
}



//get database info from the session (auth.html)

String DBdriver = session.getAttribute("dbdriver").toString();
String DBname = session.getAttribute("dbname").toString();
String DBpw = session.getAttribute("dbpassword").toString();
String DBstring = session.getAttribute("dbstring").toString();
Connection conn = null;

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

String error = "false", err_m="";
try{
FileItem file = null;

for(int j =0; j<files.size(); j++){

  file = (FileItem) files.get(j);
  Statement stmt = conn.createStatement();


  InputStream instream = file.getInputStream();
  InputStream instream2 = file.getInputStream();

  BufferedImage img = ImageIO.read(instream2);
  int factor = 10;
  int w = img.getWidth()/factor;
  int h = img.getHeight()/factor;
  BufferedImage shrunkImg = new BufferedImage(w, h, img.getType());
  for (int y=0; y < h; ++y){
      for (int x=0; x < w; ++x) {
    	  shrunkImg.setRGB(x, y, img.getRGB(x*factor, y*factor));
}}


  ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
  rset1.next();
  photo_id = rset1.getInt(1);

  String userName = session.getAttribute("userName").toString();


  stmt.execute("INSERT INTO images values("+photo_id+",'"+userName+"', "+group_id+", '"+subject+"', '"+location+"', to_date('"+date+"', 'yyyy-mm-dd'), '"+description+"', empty_blob(), empty_blob())");
  ResultSet rset = stmt.executeQuery("SELECT * from images where photo_id = "+photo_id+" for update");
  rset.next();
  BLOB thumbnail = ((OracleResultSet)rset).getBLOB(8);
  BLOB image = ((OracleResultSet)rset).getBLOB(9);

  OutputStream outstream = image.getBinaryOutputStream();
  OutputStream outstream2 = thumbnail.getBinaryOutputStream();
  ImageIO.write(shrunkImg, "jpg", outstream2);

  int size = image.getBufferSize();
  byte[] buffer = new byte[size];
  int length = -1;
  while( (length = instream.read(buffer)) !=-1){ 
    outstream.write(buffer, 0, length);
  }
  instream.close();
  instream2.close();
  outstream.close();
  outstream2.close();
  
}
} catch (Exception ex) {
  
  error = "true";
  err_m=ex.getMessage();
} finally{
  if (error.equals("false")){
  out.println("<h1>Upload Succesful!");
  conn.commit();
  } else {
  out.println("<h1>Something went wrong...");
  out.println("<p>"+err_m);
  conn.rollback();
  }
  conn.close();
}

%>





<br>
<a href="success.jsp">Home</a>





</td>
</tr>

</table>

<%@ page import="org.apache.commons.fileupload.DiskFileUpload, org.apache.commons.fileupload.FileItem, java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*, java.awt.Image, java.awt.image.BufferedImage, javax.imageio.ImageIO" %>
<%! int photo_id;
    String subject, location, description, date;
    //java.sql.Date date; %>
<%
DiskFileUpload fu = new DiskFileUpload();
List FileItems = fu.parseRequest(request);
Iterator i = FileItems.iterator();
FileItem temp = (FileItem) i.next();
FileItem item = null;
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
	  //SimpleDateFormat format = new SimpleDateFormat("mm-dd-yyyy");
	  //java.util.Date tdate = format.parse(temp.getString());
	  //date = new java.sql.Date(tdate.getTime());
	  date = temp.getString();
	  out.println(date);
	}
	}
	else
	{
	item = temp;
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

Statement stmt = conn.createStatement();

FileItem item2 = item;

InputStream instream = item.getInputStream();
InputStream instream2 = item2.getInputStream();

BufferedImage img = ImageIO.read(instream2);
int w = img.getWidth()/10;
int h = img.getHeight()/10;
BufferedImage shrunkImg = new BufferedImage(w, h, img.getType());
for (int y=0; y < h; ++y)
    for (int x=0; x < w; ++x)
    	shrunkImg.setRGB(x, y, img.getRGB(x*10, y*10));


out.println("<p>"+item.getSize()+"</p>");
ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
rset1.next();
photo_id = rset1.getInt(1);

String userName = session.getAttribute("userName").toString();


stmt.execute("INSERT INTO images values("+photo_id+",'"+userName+"', null, '"+subject+"', '"+location+"', to_date('"+date+"', 'yyyy-mm-dd'), '"+description+"', empty_blob(), empty_blob())");
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
while( (length = instream.read(buffer)) !=-1)
{ 
outstream.write(buffer, 0, length);
out.println("<p>"+size+"</p>");
}
instream.close();
instream2.close();
outstream.close();
outstream2.close();
stmt.executeUpdate("commit");
conn.close();
%>
<html>
<head>
<title>Photo Upload</title>
</head>

<body>
<a href="success.jsp">Home</a>

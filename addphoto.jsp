<%@ page import="org.apache.commons.fileupload.DiskFileUpload, org.apache.commons.fileupload.FileItem, java.io.*, java.sql.*, java.util.*, oracle.sql.*, oracle.jdbc.*" %>
<%! int photo_id; %>
<%
DiskFileUpload fu = new DiskFileUpload();
List FileItems = fu.parseRequest(request);
Iterator i = FileItems.iterator();
FileItem item = (FileItem) i.next();
while (i.hasNext() && item.isFormField())
{
	item = (FileItem) i.next();
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

InputStream instream = item.getInputStream();
ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
rset1.next();
photo_id = rset1.getInt(1);

String userName = session.getAttribute("userName").toString();

stmt.execute("INSERT INTO images values("+photo_id+",'"+userName+"', null, null, null, null, null, null, empty_blob())");
ResultSet rset = stmt.executeQuery("SELECT * from images where photo_id = "+photo_id+" for update");
rset.next();
BLOB myblob = ((OracleResultSet)rset).getBLOB(9);

OutputStream outstream = myblob.getBinaryOutputStream();
int size = myblob.getBufferSize();
byte[] buffer = new byte[size];
int length = -1;
while( (length = instream.read(buffer)) !=-1) outstream.write(buffer, 0, length);
instream.close();
outstream.close();
stmt.executeUpdate("commit");
conn.close();
%>
<html>
<head>
<title>Photo Upload</title>
</head>

<body>
<a href="success.jsp">Home</a>

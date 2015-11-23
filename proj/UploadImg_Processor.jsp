<HTML>
<TITLE>Picture upload page</TITLE>
<BODY>
	<%@ page import="java.io.*"%>
	<%@ page import="javax.servlet.*"%>
	<%@ page import="javax.servlet.http.*"%>
    <%@ page import="java.sql.*"%>
	<%@ page import="java.util.*"%>
	<%@ page import="oracle.sql.*"%>
	<%@ page import="oracle.jdbc.*"%>
	<%@ page import="java.awt.Image"%>
	<%@ page import="java.awt.image.BufferedImage"%>
	<%@ page import="javax.imageio.ImageIO"%>
	<%@ page import="java.io.*,java.util.*" %>
	<%@ page import="javax.servlet.*,java.text.*" %>
	<%@ page contentType = "text/html" import="java.util.*"%>
	

        <!--
        *  The package commons-fileupload-1.0.jar is downloaded from 
        *         http://jakarta.apache.org/commons/fileupload/ 
        *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
        *  One shall also modify the CLASSPATH to include this jar file.
        

	<%@ page import="org.apache.commons.fileupload.DiskFileUpload"%>
	<%@ page import="org.apache.commons.fileupload.FileItem"%>
	
	<!--Adapted from http://webdocs.cs.ualberta.ca/~yuan/servlets/UploadImage.java -->
	
	<%!
    	public static BufferedImage shrink(BufferedImage image, int n) {

        	int w = image.getWidth() / n;
        	int h = image.getHeight() / n;

        	BufferedImage shrunkImage = new BufferedImage(w, h, image.getType());

        	for (int y=0; y < h; ++y)
            	for (int x=0; x < w; ++x)
                	shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        	return shrunkImage;
    	}
	%>
	<%	if(request.getParameter("UploadPicComm") != null){
			String oracleId = (String)session.getAttribute("ORACLE_ID");
			String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
			Connection con = null;
		   	String driverName = "oracle.jdbc.driver.OracleDriver";
			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
			Boolean canConnect = true;
			try{
        		Class drvClass = Class.forName(driverName);
				DriverManager.registerDriver((Driver)drvClass.newInstance());
        		con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
         		con.setAutoCommit(true);
        	}
        	catch(Exception e){
        		canConnect = false;
        		out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
        		out.println("<p><b>Invalid UserName or Password!</b></p>");
        		out.println("<p><b>Press RETURN to the previous page.</b></p>");
            	out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
            	out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='RETURN'></CENTER>");
            	out.println("</FORM>");
        	}
			if(canConnect){
				String sensorId=request.getParameter("ID");
				String imgId=request.getParameter("ImgID");
				String date=request.getParameter("catchDate");
				String des=request.getParameter("Des");
				String pathimg=request.getParameter("filePath1");
				String pathrec=request.getParameter("filePath2");
				//java.util.Date now = new jave.util.Date();
				Statement s=con.createStatement();
				//String sqlStatement1 = "alter SESSION set NLS_DATE_FORMAT = 'YYYY-MM-DD'";
				String sqlStatement2="INSERT INTO images VALUES('"+imgId+"','"+sensorId+"','"+date+"','"+des+"',NULL,NULL)";
				//s.executeQuery(sqlStatement1);
				try{
					s.executeQuery(sqlStatement2);
					con.close();
					response.sendRedirect("datacurator.jsp"); 
				}
				catch(Exception e){
					out.println("<p><b>"+e.getMessage()+"</b></p>");
					out.println("<p><b>Press RETURN to the previous page.</b></p>");
					out.println("<FORM NAME='AbortForm' ACTION='datacurator.jsp' METHOD='get'>");
					out.println("    <CENTER><INPUT TYPE='submit' NAME='Cancel' VALUE='Back'></CENTER>");
					out.println("</FORM>");
					con.close();
				}
			}
	}
				/* DiskFileUpload diskFileUpload = new DiskFileUpload();
			    List files = diskFileUpload.parseRequest(request);
			    Iterator i = files.iterator();
			    FileItem file = null;
			    while (i.hasNext()) {
			    	file=(FileItem)i.next();
			    	if(file!=null){
			    		InputStream inStream=file.getInputStream();
			    		BufferedImage image=ImageIO.read(inStream);
			    	    if(image==null){
			    	    	break;
			    	    }
			    	    BufferedImage thumbNail=shrink(image,10);
			    	    BufferedImage NormalSize=shrink(image,2);
			    	    Statement s = con.createStatement();
			    	    ResultSet resSet = s.executeQuery("SELECT MAX(image_id) FROM pacs_images WHERE record_id="+recordId);
			    	    Integer maxImgId=null;
			    	    while(resSet != null && resSet.next()){
							maxImgId=(resSet.getInt(1));
						}
			    	    if(maxImgId==null){
			    	    	maxImgId=0;
			    	    }
			    	    s.execute("INSERT INTO images VALUES("+(maxImgId+1)+","+sensor_id+","+date+","+des+",empty_blob(),empty_blob())");
			    	    ResultSet resSet_II=s.executeQuery("SELECT * FROM images WHERE sensor_id ="+sensor_id+" AND image_id="+(maxImgId+1)+" FOR UPDATE");
			    	    BLOB tag=null;
			    	    while(resSet_II != null && resSet_II.next()){
			    	    	tag=((OracleResultSet)resSet_II).getBLOB("thumbnail");
						}
			    	    OutputStream outStreamForTag = tag.getBinaryOutputStream();
			    	    ImageIO.write(thumbNail,"jpg", outStreamForTag);
			    	    inStream.close();
			    	    outStreamForTag.close();
			    	    s.executeUpdate("commit");
			    	}
			    }
			    con.close();
			    //response.sendRedirect("RadPage.jsp");
			}
				/* String sqlStatement2="INSERT INTO images VALUES('"+imgId+"','"+sensorId+"','"+date+"','"+des+"','"+pathimg+"',NULL)";
				s.executeQuery(sqlStatement1);
				try{
					s.executeQuery(sqlStatement2);
					con.close();
					response.sendRedirect("datacurator.jsp"); 
				}
				catch(Exception e){
					out.println("<p><b>"+e.getMessage()+"</b></p>");
					out.println("<p><b>Press RETURN to the previous page.</b></p>");
					out.println("<FORM NAME='AbortForm' ACTION='datacurator.jsp' METHOD='get'>");
					out.println("    <CENTER><INPUT TYPE='submit' NAME='Cancel' VALUE='Back'></CENTER>");
					out.println("</FORM>");
					con.close();
				} */ 
				/* DiskFileUpload fu = new DiskFileUpload();
			    List FileItems = fu.parseRequest(request);
			    Iterator i = FileItems.iterator();
			    FileItem item = null;
			    while (i.hasNext()) {
			    	item=(FileItem)i.next();
			    	if(item!=null){
			   			InputStream inStream=item.getInputStream();
			   			BufferedImage img=ImageIO.read(inStream);
			   	        if(img==null){
			   	    	  break;
			   	        }
		    	    	BufferedImage thumbNail=shrink(img,10);
		    	    	BufferedImage NormalSize=shrink(img,2);
		    	    	Statement s = con.createStatement();
		    	    	ResultSet resSet = s.executeQuery("SELECT IMAGE_ID FROM IMAGES WHERE SENSOR_ID="+sensorId);
			    	   	Integer maxImgId=null;
			    	   	while(resSet != null && resSet.next()){
							maxImgId=(resSet.getInt(1));
						}
			   	    	if(maxImgId==null){
			   	    		maxImgId=0;
			   	    	}
			   	    	s.execute("INSERT INTO IMAGES VALUES("+(maxImgId+1)+","+sensorId+",empty_blob(),empty_blob(),empty_blob())");
		    	    	ResultSet resSet_II=s.executeQuery("SELECT * FROM IMAGES WHERE image_id="+(maxImgId+1)+"AND SENSOR_ID="+sensorId+" FOR UPDATE" );
		    	    	BLOB fullSize=null;
		    	    	BLOB normalSize=null;
		    	    	BLOB tag=null;
			    	   	while(resSet_II != null && resSet_II.next()){
			    	   		fullSize=((OracleResultSet)resSet_II).getBLOB("full_size");
			    	   		normalSize=((OracleResultSet)resSet_II).getBLOB("regular_size");
			    	   		tag=((OracleResultSet)resSet_II).getBLOB("thumbnail");
						}
			   	    	OutputStream outStreamForFullSize=fullSize.getBinaryOutputStream();
			   	    	OutputStream outStreamForNormalSize=normalSize.getBinaryOutputStream();
			   	    	OutputStream outStreamForTag = tag.getBinaryOutputStream();
			   	    	ImageIO.write(thumbNail,"jpg", outStreamForTag);
		    	    	ImageIO.write(NormalSize,"jpg", outStreamForNormalSize);
		    	    	ImageIO.write(img,"jpg", outStreamForFullSize);
		    	    	inStream.close();
		    	    	outStreamForFullSize.close();
			    	   	outStreamForNormalSize.close();
			    	   	outStreamForTag.close();
			    	   	s.executeUpdate("commit");
			    	}
			   	}*/
			    //con.close();
			    //response.sendRedirect("datacurator.jsp");
			//}
		//}
    %>
</BODY>
</HTML>

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

        <!--
        *  The package commons-fileupload-1.0.jar is downloaded from 
        *         http://jakarta.apache.org/commons/fileupload/ 
        *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
        *  One shall also modify the CLASSPATH to include this jar file.
        -->

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
	<%
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
				String recordId=(String)(session.getAttribute("SENSOR_ID")+"");

				DiskFileUpload fu = new DiskFileUpload();
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
			    	    BufferedImage thumbNail=shrink(image,10);
			    	    BufferedImage NormalSize=shrink(image,2);
			    	    Statement s = con.createStatement();
			    	    ResultSet resSet = s.executeQuery("SELECT MAX(IMAGE_ID) FROM IMAGES WHERE SENSOR_ID="+sensorId);
			    	    Integer maxImgId=null;
			    	    while(resSet != null && resSet.next()){
							maxImgId=(resSet.getInt(1));
						}
			    	    if(maxImgId==null){
			    	    	maxImgId=0;
			    	    }
			    	    s.execute("INSERT INTO IMAGE VALUES("+(maxImgId+1)+","+sensorId+",empty_blob(),empty_blob(),empty_blob())");
			    	    ResultSet resSet_II=s.executeQuery("SELECT * FROM IMAGES WHERE image_id="+(maxImgId+1)+" FOR UPDATE" AND SENSOR_ID="+sensorId+" );
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
			    	    ImageIO.write(image,"jpg", outStreamForFullSize);
			    	    inStream.close();
			    	    outStreamForFullSize.close();
			    	    outStreamForNormalSize.close();
			    	    outStreamForTag.close();
			    	    s.executeUpdate("commit");
			    	}
			    }
			    con.close();
			    response.sendRedirect("datacurator.jsp");
			}
    %>
</BODY>
</HTML>

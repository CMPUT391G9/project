import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  Adapted From http://luscar.cs.ualberta.ca:8080/yuan/GetOnePic.java.
 */
public class GetOnePic extends HttpServlet{

    public void doGet(HttpServletRequest request,HttpServletResponse response) 
    		throws ServletException, IOException{
	
	//  construct the query  from the client's QueryString
	String inputString=request.getQueryString();
	String sql;

	if (inputString.startsWith("t")){
		String[] slices=inputString.split("-");
		String recordID=slices[0].substring(1);
		String imageID=slices[1];
	    sql="SELECT thumbnail FROM pacs_images WHERE record_id="+recordID+" AND image_id="+imageID;
	}
	else if (inputString.startsWith("f")){
		String[] slices=inputString.split("-");
		String recordID=slices[0].substring(1);
		String imageID=slices[1];
		sql="SELECT full_size FROM pacs_images WHERE record_id="+recordID+" AND image_id="+imageID;
	}
	else {
		String[] slices=inputString.split("-");
		String recordID=slices[0];
		String imageID=slices[1];
	    sql="SELECT regular_size FROM pacs_images WHERE record_id="+recordID+" AND image_id="+imageID;
	}

	ServletOutputStream out = response.getOutputStream();
	HttpSession session = request.getSession(true); 
	String oracleID=(String)session.getAttribute("ORACLE_ID");
	String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");

	/*
	 *   to execute the given query
	 */
	Connection con = null;
	try {
	    con = getConnected(oracleID,oraclePassword);
	    Statement s = con.createStatement();
	    ResultSet resSet = s.executeQuery(sql);

	    if(resSet.next()){
	    	response.setContentType("image/jpeg");
	    	InputStream input = resSet.getBinaryStream(1);	    
	    	int imageByte;
	    	while((imageByte = input.read()) != -1) {
	    		out.write(imageByte);
	    	}
	    	input.close();
	    } 
	    else{
	    	out.println("no picture available");
	    }
	} 
	catch(Exception ex) {
	    out.println(ex.getMessage());
	}
	// to close the connection
	finally {
	    try {
	    	con.close();
	    } 
	    catch (SQLException ex) {
	    	out.println(ex.getMessage());
	    }
	}
    }

    /*
     *   Connect to the specified database
     */
    private Connection getConnected(String oracleID,String oraclePassword) throws Exception {
    	
    	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    	String driverName = "oracle.jdbc.driver.OracleDriver";


    	Class drvClass = Class.forName(driverName); 
    	DriverManager.registerDriver((Driver) drvClass.newInstance());
    	return DriverManager.getConnection(dbstring,oracleID,oraclePassword);
    }
}

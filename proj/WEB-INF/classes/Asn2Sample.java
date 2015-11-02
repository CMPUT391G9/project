import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Asn2Sample extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		String SQLStatement = request.getParameter("SQLStatement");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
			"Transitional//EN\">\n" +
			"<HTML>\n" +
			"<HEAD><TITLE>Asn2Sample</TITLE></HEAD>\n" +
			"<BODY>\n" +
			"<H1>" +
			SQLStatement + 
			"</H1>\n" +
			"</BODY></HTML>");
	}
}

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
public class FirstServlet extends GenericServlet {
    public void service(ServletRequest request, ServletResponse response)
    throws IOException
    {  
        // Tell the Web server that the response is HTML
        response.setContentType("text/html");

        // Get the Printwriter for writing out the response
        PrintWriter out = response.getWriter();

        // Write the HTML back to the browser
        out.println("<html>"); 
        out.println("<body>");
        out.println("<h1>Welcome to CMPUT391 Lab!</h1>");
        out.println("</body>");
        out.println("</html>");
    }
}

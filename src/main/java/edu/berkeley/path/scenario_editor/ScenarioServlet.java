/**
* Copyright ©2008. The Regents of the University of California (Regents).
* All Rights Reserved. Permission to use, copy, modify, and distribute this
* software and its documentation for educational, research, and not-for-profit
* purposes, without fee and without a signed licensing agreement, is hereby
* granted, provided that the above copyright notice, this paragraph and the
* following two paragraphs appear in all copies, modifications, and
* distributions. Contact The Office of Technology Licensing, UC Berkeley,
* 2150 Shattuck Avenue, Suite 510, Berkeley, CA 94720-1620, (510) 643-7201,
* for commercial licensing opportunities.
*
* IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT,
* SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS,
* ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
* REGENTS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED
* TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE. THE SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED
* HEREUNDER IS PROVIDED "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE
* MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
**/
package edu.berkeley.path.scenario_editor;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.OutputKeys;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.OutputStream;

/**
* This Class Handles Ajax requests to and returns them to the client.
*
*/
public class ScenarioServlet extends HttpServlet {
  
  /**
  *
  * Handles GET Ajax request
  *
  * @param request Ajax request for system 
  * @param response The HttpServletResponse object containing JSON
  */
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
                                          throws ServletException, IOException {
    try {
      setUpDownload(response);
    } catch(Exception e) {
      e.printStackTrace();
      //TODO how are we logging?
    }
  
  }
  
  /**
  *
  * Handles POST Ajax request
  *
  * @param request Ajax request for system 
  * @param response The HttpServletResponse object containing JSON
  */
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
                                          throws ServletException, IOException {
    try {
        getPostData(request);
      
    } catch(Exception e) {
      e.printStackTrace();
      //TODO how are we logging?
    }
  }
  
  private void setUpDownload(HttpServletResponse response)
  {
    try{
      response.setContentType("text/plain");
      response.setHeader("Content-Disposition","attachment;filename=scenario.xml");
      ServletContext ctx = getServletContext();
      InputStream is = ctx.getResourceAsStream("/temp-download/scenario.xml");
 
      int read=0;
      byte[] bytes = new byte[1024];
      OutputStream os = response.getOutputStream();
 
      while((read = is.read(bytes))!= -1){
        os.write(bytes, 0, read);
      }
      os.flush();
      os.close();
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
  
  private void getPostData(HttpServletRequest req) {
    StringBuilder sb = new StringBuilder();
    try {
        BufferedReader reader = req.getReader();

        String line="";
        line = reader.readLine();
        while (line != null){
            sb.append(line).append("\n");
            line = reader.readLine();
        } 
        reader.close();

        formatXML(sb.toString());
    } catch(Exception e) {
        e.printStackTrace();
        //TODO how are we logging?
    }
  }
  
  public void formatXML(String unformattedXml) {
      try {
        StreamSource xmlInput = new StreamSource(new StringReader(unformattedXml));
        StringWriter stringWriter = new StringWriter();
        StreamResult xmlOutput = new StreamResult(stringWriter);
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        transformerFactory.setAttribute("indent-number", 2);
        Transformer transformer = transformerFactory.newTransformer(); 
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.transform(xmlInput, xmlOutput);
        ServletContext ctx = getServletContext();
        FileWriter fw = new FileWriter(ctx.getRealPath(".") + "/temp-download/scenario.xml");
        fw.write(xmlOutput.getWriter().toString().trim());
        fw.close();
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
    }
}
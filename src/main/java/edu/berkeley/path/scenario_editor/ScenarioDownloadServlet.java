/**
 * Copyright (c) 2012, Regents of the University of California
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 *   Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
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
@SuppressWarnings("serial")
public class ScenarioDownloadServlet extends HttpServlet {
  
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
    }
  
  }
  
  /**
  *
  * Handles POST Ajax request
  *
  * @param request Ajax request for system 
  * @param response The HttpServletResponse object is not used here
  */
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
                                          throws ServletException, IOException {
    try {
      getPostData(request);
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
  
  /**
  * Takes the response object and sets up the file for download
  *
  * @param response The HttpServletResponse object used to hold the file contents
  */
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
  
  /**
  * Takes the request object, gets the xml data and writes it to the file system
  * after formatting the xml
  *
  * @param request The HttpServletRequest object holds xml file contents
  */
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
    }
  }
  
  /**
  * A helper method used to format and write the xml to the file system.
  *
  * @param unformattedXML The string of xml not formatted
  */
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
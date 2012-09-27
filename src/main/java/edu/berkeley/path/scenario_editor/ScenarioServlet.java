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

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
* This Class Handles Ajax requests to retrieve Alarm and System information and
* returns them to the client.
*
*/
public class ScenarioServlet extends HttpServlet {
  /**
  *
  * Handles Get Ajax request from Alarm dashboard and sends back all
  * configured alarm and system information
  *
  * @param request Ajax request for system and alarm information
  * @param response The HttpServletResponse object containing JSON system and
  * alarm information
  */
  protected void doGet(HttpServletRequest request, HttpServletResponse response) 
                                                    throws ServletException, IOException {
  
    String jsonTest = "{'test':'json'}";
    
    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_OK);
    response.getWriter().print(jsonTest);
  
  }
}
package edu.berkeley.path.scenario_editor;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for ScenarioDownloadServlet.
 */
public class TestScenarioDownloadServlet 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public TestScenarioDownloadServlet( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( TestScenarioDownloadServlet.class );
    }

    /**
     * Rigourous Test ;)
     */
    public void testFormatXML()
    {
        assertTrue( true );
    }
}

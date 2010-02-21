<cfcomponent extends="modelglue.gesture.test.ModelGlueAbstractTestCase">
	
	<cfset this.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml">
	
	<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
		<cfset createModelGlueIfNotDefined(this.coldspringPath) />
		<cfset variables.urlManager = createObject("component", "ModelGlue.gesture.eventrequest.url.SesUrlManager").init() />
		<cfset urlManager.setModelGlue(mg) />			
	</cffunction>
	
	<cffunction name="testPopulateLocation" returntype="void" access="public">
		<cfset var ec = mg.getEventContextFactory().new() />
		<cfset var mockCgi = structNew() />
		
		<cfset mockCgi.SCRIPT_NAME = "index.cfm" />
		<cfset mockCgi.PATH_INFO = "" />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset debug(urlManager.extractValues(mockCgi))>
		
		<cfset assertEquals( "event", ec.getValue("eventValue"), "Event value from config file not set! (was : '#ec.getValue("eventValue")#')") />
		<cfset assertEquals(cgi.script_name, ec.getValue("self")) />
		<cfset assertEquals("#cgi.script_name#/", ec.getValue("myself")) />
	</cffunction>
	
	<cffunction name="testExtractValues" returntype="void" access="public">
		<cfset var vals = "" />
		<cfset var mockCgi = structNew() />
		<cfset var ec = mg.getEventContextFactory().new() />
		
		<cfset mockCgi.SCRIPT_NAME = "index.cfm" />
		<cfset mockCgi.PATH_INFO = "" />
		
		<cfset vals = urlManager.extractValues(mockCgi) />
		<cfset assertFalse(structKeyExists(vals, "urlValueName"), "urlValueName found before definition!") />
		
		<cfset mockCgi.PATH_INFO = "eventValue/urlKey/urlValue/urlKey2/urlValue2" />
		<cfset vals = variables.urlManager.extractValues(mockCgi) />
		<cfset debug(vals)>
		
		<cfset assertTrue(structKeyExists(vals, "urlKey"), "urlKey not found after definition!") />
		<cfset assertEquals("urlValue", vals.urlKey, "urlKey value incorrect!") />
		<cfset assertEquals("urlValue2", vals.urlKey2, "urlKey2 value incorrect!") />
	</cffunction>
	
	<cffunction name="testLinkTo" returntype="void" access="public">
		<cfset var resultUrl = "" />
		<cfset var context = structNew() />
		<cfset var ec = mg.getEventContextFactory().new() />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset ec.setValue("urlValueName", "urlValue") />
		<cfset ec.setValue("urlValueName2", "urlValue2") />
		
		<cfset resultUrl = urlManager.linkTo("someEvent", "", "", ec) />
		<cfset assertEquals("#ec.getValue("myself")#someEvent", resultUrl, "Simple url not built.  Was ('#resultUrl#').") />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset resultUrl = urlManager.linkTo("someEvent", "urlValueName,urlValueName2", "anchorPosition", ec) />
		<cfset assertEquals("#ec.getValue("myself")#someEvent/urlValueName/urlValue/urlValueName2/urlValue2##anchorPosition", resultUrl, "Complex url not built. Was ('#resultUrl#')") />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset context.urlValueName = "alternateUrlValue" />
		<cfset resultUrl = urlManager.linkTo("someEvent", "urlValueName,urlValueName2", "anchorPosition", ec, context) />
		<cfset assertEquals("#ec.getValue("myself")#someEvent/urlValueName/alternateUrlValue/urlValueName2/urlValue2##anchorPosition", resultUrl, "Complex url not built using optional context. Was ('#resultUrl#')") />
	</cffunction>
	
</cfcomponent>
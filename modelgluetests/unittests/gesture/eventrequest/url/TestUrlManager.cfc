<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">
	
	<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/eventrequest/url/ColdSpring.xml">
	
	<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
		<cfset createModelGlueIfNotDefined(this.coldspringPath) />
		<cfset variables.urlManager = createObject("component", "ModelGlue.gesture.eventrequest.url.UrlManager").init() />
		<cfset variables.urlManager.setModelGlue(mg) />			
	</cffunction>
	
	<cffunction name="testPopulateLocation" returntype="void" access="public">
		<cfset var ec = mg.getEventContextFactory().new() />
		
		<cfset variables.urlManager.populateLocation(ec) />
		
		<cfset assertTrue(ec.getValue("eventValue") eq "event", "Event value from config file not set! (was : '#ec.getValue("eventValue")#')") />
		<cfset assertTrue(ec.getValue("self") eq "defaultTemplateValue", "Default template value from config file not set! (was : '#ec.getValue("self")#')") />
		<cfset assertTrue(ec.getValue("myself") eq "defaultTemplateValue?event=", "Myself from config file not set! (was : '#ec.getValue("myself")#')") />
	</cffunction>
	
	<cffunction name="testExtractValues" returntype="void" access="public">
		<cfset var vals = "" />
		<cfset var ec = mg.getEventContextFactory().new() />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset vals = urlManager.extractValues() />
		
		<cfset assertFalse(structKeyExists(vals, "urlValueName"), "urlValueName found before definition!") />
		
		<cfset url.urlValueName = "urlValue" />
		<cfset vals = variables.urlManager.extractValues(url) />
		
		<cfset assertTrue(structKeyExists(vals, "urlValueName"), "urlValueName not found after definition!") />
		<cfset assertTrue(vals.urlValueName eq "urlValue", "urlValueName value incorrect!") />
	</cffunction>
	
	<cffunction name="testLinkTo" returntype="void" access="public">
		<cfset var resultUrl = "" />
		<cfset var context = structNew() />
		<cfset var ec = mg.getEventContextFactory().new() />
		
		<cfset variables.urlManager.populateLocation(ec) />
		<cfset ec.setValue("urlValueName", "urlValue") />
		<cfset ec.setValue("urlValueName2", "urlValue2") />
		
		<cfset resultUrl = urlManager.linkTo("someEvent", "", "", ec) />
		<cfset assertTrue(resultUrl eq "#ec.getValue("myself")#someEvent", "Simple url not built.  Was ('#resultUrl#') not (#ec.getValue("myself")#someEvent)") />
		
		<cfset resultUrl = urlManager.linkTo("someEvent", "urlValueName,urlValueName2", "anchorPosition", ec) />
		<cfset assertTrue(resultUrl eq "#ec.getValue("myself")#someEvent&urlValueName=urlValue&urlValueName2=urlValue2##anchorPosition", "Complex url not built.  Was ('#replace(resultUrl, chr(35), chr(35) & chr(35))#').") />
		
		<cfset context.urlValueName = "alternateUrlValue" />
		<cfset resultUrl = urlManager.linkTo("someEvent", "urlValueName,urlValueName2", "anchorPosition", ec, context) />
		<cfset assertTrue(resultUrl eq "#ec.getValue("myself")#someEvent&urlValueName=alternateUrlValue&urlValueName2=urlValue2##anchorPosition", "Complex url not built using optional context.  Was ('#replace(resultUrl, chr(35), chr(35) & chr(35))#').") />
	</cffunction>
	
</cfcomponent>
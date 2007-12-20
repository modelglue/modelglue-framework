<cfcomponent extends="org.cfcunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.XMLColdSpringBootstrapper") />
</cffunction>

<cffunction name="testPopulateLocation" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var urlManager = "" />
	<cfset var mg = "" />
	<cfset var ec = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset urlManager = mg.getInternalBean("modelglue.UrlManager") />
	
	<cfset ec = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	
	<cfset urlManager.populateLocation(ec) />
	
	<cfset assertTrue(ec.getValue("eventValue") eq "eventValue", "Event value from config file not set! (was : '#ec.getValue("eventValue")#')") />
	<cfset assertTrue(ec.getValue("self") eq "defaultTemplateValue", "Default template value from config file not set! (was : '#ec.getValue("self")#')") />
	<cfset assertTrue(ec.getValue("myself") eq "defaultTemplateValue?eventValue=", "Myself from config file not set! (was : '#ec.getValue("myself")#')") />
</cffunction>

<cffunction name="testExtractValues" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var urlManager = "" />
	<cfset var mg = "" />
	<cfset var vals = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset urlManager = mg.getInternalBean("modelglue.UrlManager") />

	<cfset vals = urlManager.extractValues() />
	
	<cfset assertFalse(structKeyExists(vals, "urlValueName"), "urlValueName found before definition!") />
	
	<cfset url.urlValueName = "urlValue" />
	
	<cfset vals = urlManager.extractValues() />
	
	<cfset assertTrue(structKeyExists(vals, "urlValueName"), "urlValueName not found after definition!") />
	<cfset assertTrue(vals.urlValueName eq "urlValue", "urlValueName value incorrect!") />
</cffunction>

<cffunction name="testLinkTo" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var urlManager = "" />
	<cfset var mg = "" />
	<cfset var resultUrl = "" />
	<cfset var ec = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset urlManager = mg.getInternalBean("modelglue.UrlManager") />
	
	<cfset ec = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />

	<cfset ec.setValue("urlValueName", "urlValue") />
	<cfset ec.setValue("urlValueName2", "urlValue2") />

	<cfset resultUrl = urlManager.linkTo(ec, "someEvent") />
	
	<cfset assertTrue(resultUrl eq "#ec.getValue("myself")#someEvent", "Simple url not built.  Was ('#resultUrl#').") />	

	<cfset resultUrl = urlManager.linkTo(ec, "someEvent", "urlValueName,urlValueName2", "anchorPosition") />
	
	<cfset assertTrue(resultUrl eq "#ec.getValue("myself")#someEvent&urlValueName=urlValue&urlValueName2=urlValue2##anchorPosition", "Complex url not built.  Was ('#resultUrl#').") />	
</cffunction>

</cfcomponent>
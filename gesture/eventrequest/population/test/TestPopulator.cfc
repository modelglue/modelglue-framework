<cfcomponent extends="org.cfcunit.framework.TestCase" output="false">

<cffunction name="testStructBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = createObject("component", "ModelGlue.gesture.eventrequest.population.StructBasedPopulator").init() />
	
	<cfset source.someKey = "someValue" />
	
	<cfset pop.populate(ctx, source) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someValue", "value not in context") />
</cffunction>

<cffunction name="testUrlBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = createObject("component", "ModelGlue.gesture.eventrequest.population.UrlPopulator").init() />
	
	<cfset url.someKey = "someUrlValue" />
	
	<cfset pop.populate(ctx) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someUrlValue", "value not in context") />
</cffunction>

<cffunction name="testFormBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = createObject("component", "ModelGlue.gesture.eventrequest.population.FormPopulator").init() />
	
	<cfset form.someKey = "someFormValue" />
	
	<cfset pop.populate(ctx) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someFormValue", "value not in context") />
</cffunction>

</cfcomponent>
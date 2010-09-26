<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase" output="false">

	<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/eventrequest/url/ColdSpring.xml">

	<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
		<cfset createModelGlueIfNotDefined(this.coldspringPath) />
	</cffunction>


<cffunction name="testStructBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = mg.getEventContextFactory().new() />
	<cfset var pop = createObject("component", "ModelGlue.gesture.eventrequest.population.StructBasedPopulator").init() />
	<cfset var source = {} />
	
	<cfset source.someKey = "someValue" />
	
	<cfset pop.populate(ctx, source) />
	
    <cfset assertEquals("someValue", ctx.getValue("someKey"), "value not in context") />
</cffunction>

<cffunction name="testUrlBasedPopulator" output="false" returntype="void" access="public">
	<cfset var urlManager = "" />
	<cfset var ctx = mg.getEventContextFactory().new() /> />
	<cfset var pop = mg.getInternalBean("modelGlue.urlPopulator")/>
	

	<cfset url.someKey = "someUrlValue" />
	
	<cfset pop.populate(ctx) />
	
    <cfset assertEquals("someUrlValue", ctx.getValue("someKey"), "value not in context") />
</cffunction>

<cffunction name="testFormBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = mg.getEventContextFactory().new() /> />
	<cfset var pop = mg.getInternalBean("modelGlue.formPopulator") />
	
	<cfset form.someKey = "someFormValue" />
	
	<cfset pop.populate(ctx) />
	
	<cfset assertEquals("someFormValue", ctx.getValue("someKey"), "value not in context") />
</cffunction>

</cfcomponent>
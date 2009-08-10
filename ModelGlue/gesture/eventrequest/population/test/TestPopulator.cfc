<cfcomponent extends="modelglue.gesture.test.ModelGlueAbstractTestCase" output="false">

	<cfset this.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml">

	<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
		<cfset createModelGlueIfNotDefined(this.coldspringPath) />
	</cffunction>


<cffunction name="testStructBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = createObject("component", "ModelGlue.gesture.eventrequest.population.StructBasedPopulator").init() />
	<cfset var source = {} />
	
	<cfset source.someKey = "someValue" />
	
	<cfset pop.populate(ctx, source) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someValue", "value not in context") />
</cffunction>

<cffunction name="testUrlBasedPopulator" output="false" returntype="void" access="public">
	<cfset var urlManager = "" />
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = mg.getInternalBean("modelGlue.urlPopulator")/>
	

	<cfset url.someKey = "someUrlValue" />
	
	<cfset pop.populate(ctx) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someUrlValue", "value not in context") />
</cffunction>

<cffunction name="testFormBasedPopulator" output="false" returntype="void" access="public">
	<cfset var ctx = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset var pop = mg.getInternalBean("modelGlue.formPopulator") />
	
	<cfset form.someKey = "someFormValue" />
	
	<cfset pop.populate(ctx) />
	
	<cfset assertTrue(ctx.getValue("someKey") eq "someFormValue", "value not in context") />
</cffunction>

</cfcomponent>
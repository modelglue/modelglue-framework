<cfcomponent extends="org.cfcunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.XMLColdSpringBootstrapper") />
</cffunction>

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = createObject("component", "ModelGlue.gesture.ModelGlue") />
	<cfset var testVal = createUUID() />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset boot.storeModelGlue(mg) />
	
	<cfset boot.someRandomVar = testVal />
	
	<cfset assertTrue(request._modelglue.bootstrapper.bootstrapper.someRandomVar eq testVal , "XMLColdSpringBootstrapper not stored in request scope.") />
</cffunction>

</cfcomponent>
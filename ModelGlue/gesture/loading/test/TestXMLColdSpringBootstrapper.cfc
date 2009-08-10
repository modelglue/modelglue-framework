<cfcomponent  extends="modelglue.gesture.test.ModelGlueAbstractTestCase">

<cfset this.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml">

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createObject("component", "ModelGlue.gesture.loading.XMLColdSpringBootstrapper") />
	<cfset var mg = createObject("component", "ModelGlue.gesture.ModelGlue") />
	<cfset var testVal = createUUID() />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	<cfset boot.coreColdspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset boot.storeModelGlue(mg) />
	
	<cfset boot.someRandomVar = testVal />
	
	<cfset assertTrue(request._modelglue.bootstrap.bootstrapper.someRandomVar eq testVal , "XMLColdSpringBootstrapper not stored in request scope.") />
</cffunction>

</cfcomponent>
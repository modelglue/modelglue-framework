<cfcomponent  extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/loading/ColdSpring.xml">

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createObject("component", "ModelGlue.gesture.loading.XMLColdSpringBootstrapper") />
	<cfset var mg = createObject("component", "ModelGlue.gesture.MemoizedModelGlue") />
	<cfset var testVal = createUUID() />
	
	<cfset boot.coldspringPath = "/modelgluetests/unittests/gesture/loading/ColdSpring.xml" />
	<cfset boot.coreColdspringPath = "/modelgluetests/unittests/gesture/loading/ColdSpring.xml" />
	<cfset boot.modelGlueBeanName = "modelglue.ModelGlue">
	
	<cfset boot.storeModelGlue(mg) />
	
	<cfset boot.someRandomVar = testVal />
	
	<cfset assertTrue(request._modelglue.bootstrap.bootstrapper.someRandomVar eq testVal , "XMLColdSpringBootstrapper not stored in request scope.") />
</cffunction>

</cfcomponent>
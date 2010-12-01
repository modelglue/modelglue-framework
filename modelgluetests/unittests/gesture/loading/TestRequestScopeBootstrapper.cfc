<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">
	
<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/loading/ColdSpring.xml">

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper(this.coldspringPath) />
	<cfset var mg = createObject("component", "ModelGlue.gesture.MemoizedModelGlue") />
	
	<cfset boot.storeModelGlue(mg) />
	<cfset assertTrue(getMetadata(request._modelglue.bootstrap.framework).name eq "ModelGlue.gesture.MemoizedModelGlue", "ModelGlue instance not stored in request scope.") />
</cffunction>

</cfcomponent>



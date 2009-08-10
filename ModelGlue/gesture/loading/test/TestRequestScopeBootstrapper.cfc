<cfcomponent extends="modelglue.gesture.test.ModelGlueAbstractTestCase">
	
<cfset this.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml">

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper(this.coldspringPath) />
	<cfset var mg = createObject("component", "ModelGlue.gesture.ModelGlue") />
	
	<cfset boot.storeModelGlue(mg) />
	<cfset assertTrue(getMetadata(request._modelglue.bootstrap.framework).name eq "ModelGlue.gesture.ModelGlue", "ModelGlue instance not stored in request scope.") />
</cffunction>

</cfcomponent>



<cfcomponent extends="org.cfcunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.RequestScopeBootstrapper") />
</cffunction>

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = createObject("component", "ModelGlue.gesture.ModelGlue") />
	
	<cfset boot.storeModelGlue(mg) />
	
	<cfset assertTrue(getMetadata(request._modelglue.bootstrapper.framework).name eq "ModelGlue.gesture.ModelGlue", "ModelGlue instance not stored in request scope.") />
</cffunction>

</cfcomponent>



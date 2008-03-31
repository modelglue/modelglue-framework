<cfcomponent extends="mxunit.framework.TestCase" output="false">

<cffunction name="testFacade" access="public" returntype="void">
	<cfset var facade = createObject("component", "ModelGlue.gesture.externaladapters.session.AdobeColdFusionSessionFacade").init() />
	
	<cfset assertTrue(session.sessionId eq facade.getSessionIdentifier()) />
</cffunction>

</cfcomponent>
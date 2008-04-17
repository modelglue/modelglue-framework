<cfcomponent extends="org.cfcunit.framework.TestCase" hint="Tests the various ModelGlue.cfm templates.">

<cffunction name="testGestureModelGlueTemplate" returntype="void" access="public">
	<cfset var expectedMgXmlPath = expandPath("./config/ModelGlue.xml") />
	<cfset var expectedCsXmlPath = expandPath("./config/ColdSpring.xml") />
	
	<cfset structDelete(application, "_modelglue") />

	<cftry>
		<cfinclude template="/ModelGlue/gesture/ModelGlue.cfm" />
		<cfcatch>
			<!--- 
				It's going to try to run a request and load files it can't find.  We just
				care that paths are set up correctly...
			--->
		</cfcatch>
	</cftry>
	<cfset assertTrue(structKeyExists(request, "_modelglue"), "_modelglue not in request") />
	<cfset assertTrue(structKeyExists(request._modelglue, "bootstrapper"), "bootstrapper not created") />
	
	<cfset assertTrue(request._modelglue.bootstrapper.bootstrapper.initialModulePath eq expectedMgXmlPath, "initialModulePath not as expected (expected '#expectedMgXmlPath#', was '#request._modelglue.bootstrapper.bootstrapper.initialModulePath#')") />
	<cfset assertTrue(request._modelglue.bootstrapper.bootstrapper.coldspringPath eq expectedCsXmlPath, "coldspringPath not as expected (expected '#expectedCsXmlPath#', was '#request._modelglue.bootstrapper.bootstrapper.coldspringPath#')") />
	
</cffunction>

</cfcomponent>
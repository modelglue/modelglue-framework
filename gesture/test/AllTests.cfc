<cfcomponent displayname="AllTests" output="false">

<cffunction name="suite" returntype="org.cfcunit.framework.Test" access="public" output="false">
	<cfset var suite = CreateObject("component", "org.cfcunit.framework.TestSuite").init("Test Suite")>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.test.TestModelGlue"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventrequest.test.TestEventContext"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventhandler.test.TestEventHandler"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.collections.test.TestViewCollection"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.collections.test.TestMapCollectionImplementation"))>
	
	<cfreturn suite/>
</cffunction>

</cfcomponent>
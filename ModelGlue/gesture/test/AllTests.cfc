<cfcomponent displayname="AllTests" output="false">

<cffunction name="suite" returntype="org.cfcunit.framework.Test" access="public" output="false">
	<cfset var suite = CreateObject("component", "org.cfcunit.framework.TestSuite").init("Test Suite")>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.test.TestModelGlue"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.module.test.TestXMLModuleLoader"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.loading.test.TestRequestScopeBootstrapper"))>
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.loading.test.TestColdSpringBootstrapper"))>
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.loading.test.TestXMLColdSpringBootstrapper"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventrequest.population.test.TestPopulator"))>
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventrequest.url.test.TestUrlManager"))>
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventrequest.test.TestEventContext"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.eventhandler.test.TestEventHandler"))>


	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.factory.test.TestTypeDefaultMapBasedFactory"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.collections.test.TestViewCollection"))>
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.collections.test.TestMapCollectionImplementation"))>

	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.externaladapters.beaninjection.test.TestColdSpringBeanInjector")) />	
	<cfset suite.addTestSuite(CreateObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.test.TestCollectionBeanPopulator")) />	

	<cfreturn suite/>
</cffunction>

</cfcomponent>
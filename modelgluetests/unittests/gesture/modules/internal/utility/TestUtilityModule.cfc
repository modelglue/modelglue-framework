<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml">

<cffunction name="testSettingDisableDebugInAFewWays" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var loader = "" />
	<cfset var obj = "" />
	<cfset var beanFactory = "" />
	<cfset var ec ="" />
	<cfset beanFactory = mg.getInternalBeanFactory() />
	<cfset beanFactory.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, "/ModelGlue/gesture/modules/internal/utility/config/utility.xml") />
	<cfset loader.load(mg, "/modelgluetests/unittests/gesture/module/disableDebugXmlModule.xml") />

	<cfparam name="request.modelGlueSuppressDebugging" default="false" >
	<cfset structClear(url) />	
	<cfset url.event = "PlainEventHandlerWithDebugNotSet" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS false, "Disable Debug setting did not default to false") />
	<cfset structClear(url) />	
	<cfset url.event = "PlainEventHandlerWithDebugFalse" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS false, "Disable Debug setting did not set to false naturally") />
	<cfset request.modelGlueSuppressDebugging = false />
	<cfset structClear(url) />	
	<cfset url.event = "eventHandlerWithDisabledDebug" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS true, "Disable Debug setting did not work when modelglue.disableModelGlueDebugging was broadcast") />
	<cfset request.modelGlueSuppressDebugging = false />
	<cfset structClear(url) />	
	<cfset url.event = "eventHandlerWithEventTypeOfDisabledDebug" />
	<cfset ec = mg.handleRequest() />
	<cfset assertTrue( request.modelGlueSuppressDebugging IS true, "Disable Debug setting did not work when event type had modelglue.disableModelGlueDebugging broadcast ") />
	<cfset structClear(url) />	
	
	<!--- If we don't throw error, we made it. --->
</cffunction>


</cfcomponent>
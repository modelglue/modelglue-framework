<cfcomponent extends="mxunit.framework.TestCase"> 

<cffunction name="testPathInjection" access="public" returntype="void">  
	<cfset var injector = createObject("component", "ModelGlue.gesture.helper.HelperInjector").init() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />
	
	<!--- chuckle...this'll actually inject this test case. --->
	<cfset injector.injectPath(target, "/ModelGlue/gesture/helper/test/") />

	<cfset assertTrue(structKeyExists(target, "includeHelper")) />
	<cfset assertTrue(target.includeHelper.helperFunction() eq "I am an include helper.") />	

	<cfset assertTrue(structKeyExists(target, "componentHelper")) />
	<cfset assertTrue(target.componentHelper.helperFunction() eq "I am a component helper.") />	
</cffunction>

<cffunction name="testIncludeInjection" access="public" returntype="void">  
	<cfset var injector = createObject("component", "ModelGlue.gesture.helper.HelperInjector").init() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />

	<cfset injector.injectInclude(target, "/ModelGlue/gesture/helper/test/IncludeHelper.cfm") />

	<cfset assertTrue(structKeyExists(target, "includeHelper")) />
	<cfset assertTrue(target.includeHelper.helperFunction() eq "I am an include helper.") />	
</cffunction>

<cffunction name="testComponentInjection" access="public" returntype="void">  
	<cfset var injector = createObject("component", "ModelGlue.gesture.helper.HelperInjector").init() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />

	<cfset injector.injectComponent(target, "/ModelGlue/gesture/helper/test/ComponentHelper.cfc") />

	<cfset assertTrue(structKeyExists(target, "componentHelper")) />
	<cfset assertTrue(target.componentHelper.helperFunction() eq "I am a component helper.") />	
</cffunction>

</cfcomponent>
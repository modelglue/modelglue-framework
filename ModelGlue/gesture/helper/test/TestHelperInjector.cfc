<cfcomponent extends="mxunit.framework.TestCase"> 

<cffunction name="createHelperInjector" output="false" access="public" returntype="any">
	<cfset var helperInjector = createObject("component", "ModelGlue.gesture.helper.HelperInjector").init() />
	<cfset helperInjector.setBeanInjector(createBeanInjector()) />
	<cfreturn helperInjector />
</cffunction>

<cffunction name="createBeanInjector" output="false" access="public" returntype="any">
	<cfset var bf = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset bf.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfreturn bf.getBean("injector") />
</cffunction>

<cffunction name="testPathInjection" access="public" returntype="void">  
	<cfset var injector = createHelperInjector() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />
	
	<!--- chuckle...this'll actually inject this test case. --->
	<cfset injector.injectPath(target, "/ModelGlue/gesture/helper/test/") />

	<cfset assertTrue(structKeyExists(target, "includeHelper")) />
	<cfset assertTrue(target.includeHelper.helperFunction() eq "I am an include helper.") />	

	<cfset assertTrue(structKeyExists(target, "componentHelper")) />
	<cfset assertTrue(target.componentHelper.helperFunction() eq "I am a component helper.") />	
</cffunction>

<cffunction name="testIncludeInjection" access="public" returntype="void">  
	<cfset var injector = createHelperInjector() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />

	<cfset injector.injectInclude(target, "/ModelGlue/gesture/helper/test/IncludeHelper.cfm") />

	<cfset assertTrue(structKeyExists(target, "includeHelper")) />
	<cfset assertTrue(target.includeHelper.helperFunction() eq "I am an include helper.") />	
</cffunction>

<cffunction name="testComponentInjection" access="public" returntype="void">  
	<cfset var injector = createHelperInjector() />
	<cfset var target = createObject("component", "ModelGlue.gesture.helper.Helpers") />
	<cfset var bean = "" />
	<cfset var bean2 = "" />

	<cfset injector.injectComponent(target, "/ModelGlue/gesture/helper/test/ComponentHelper.cfc") />

	<cfset assertTrue(structKeyExists(target, "componentHelper")) />
	<cfset assertTrue(target.componentHelper.helperFunction() eq "I am a component helper.") />	

	<cfset bean = target.componentHelper.getBean() />
	<cfset assertTrue(isObject(bean), "componentHelper.getBean() not object") />
	<cfset assertTrue(getMetadata(bean).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean", "componentHelper.getBean() not right type!") />
	<cfset bean2 = target.componentHelper.getBean2() />
	<cfset assertTrue(isObject(bean2), "componentHelper.getBean2() not object") />
	<cfset assertTrue(getMetadata(bean2).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean2", "componentHelper.getBean2() not right type!") />
</cffunction>

</cfcomponent>
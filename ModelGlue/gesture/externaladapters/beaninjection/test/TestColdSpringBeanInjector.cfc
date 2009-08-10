<cfcomponent extends="mxunit.framework.TestCase">

<cfset createBeanFactory() />

<cffunction name="createInjector" output="false" access="public">
	<cfreturn createBeanFactory().getBean("injector") />
</cffunction>

<cffunction name="createBeanFactory" output="false" access="public">
	<cfset variables.bf = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset variables.bf.loadBeans(expandPath("/ModelGlue/gesture/externaladapters/beaninjection/test/ColdSpring.xml")) />
	
	<cfreturn variables.bf />
</cffunction>

<cffunction name="createTargetBean" output="false">
	<cfreturn createObject("component", "ModelGlue.gesture.externaladapters.beaninjection.test.Target") />
</cffunction>

<cffunction name="testCreationInjectionHooks" output="false" returntype="void" access="public">
	<cfset var bean = createTargetBean() />
	<cfset var injector = createInjector() />
	<cfset var beanVars = "" />

	<cfset assertFalse(injector.hasInjectionHooks(bean), "injection hooks reported as existing before creation!") />
		
	<cfset injector.createInjectionHooks(bean) />
	
	<cfset assertTrue(injector.hasInjectionHooks(bean), "injection hooks reported as not existing after creation!") />
	<cfset assertTrue(structKeyExists(bean, "_modelGlueBeanInjection_getVariablesScope"), "getVariablesScope didn't exist") />
	
	<cfset beanVars = bean._modelGlueBeanInjection_getVariablesScope() />
	
	<cfset assertTrue(bean.getVariablesValue() eq "internallySet", "initial variables value wrong") />
	
	<cfset beanVars._value = "externallySetValue" />
	
	<cfset assertTrue(bean.getVariablesValue("externallySetValue") eq "externallysetValue", "variables value not set") />
</cffunction>

<cffunction name="testInject" output="false" returntype="void" access="public">
	<cfset var bean = createTargetBean() />
	<cfset var injector = createInjector() />
	<cfset var beanId = "" />
	<cfset var beanVars = "" />
	
	<cfloop list="bean,bean2" index="beanId">
		<cfset injector.injectBean(beanId, bean) />
	</cfloop>
	
	<cfset beanVars = bean._modelGlueBeanInjection_getVariablesScope() />
	
	<cfset assertTrue(structKeyExists(beanVars, "beans"), "'beans' struct not created") />
	<cfset assertTrue(structKeyExists(beanVars.beans, "bean"), "'bean' not in 'beans' scope") />
	<cfset assertTrue(isObject(beanVars.beans.bean), "'bean' in 'beans' not object") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean", "'bean' in 'beans' not right type!") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean2).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean2", "'bean2' in 'beans' not right type!") />
</cffunction>

<cffunction name="testMetadataInjection" output="false" returntype="void" access="public">
	<cfset var bean = createTargetBean() />
	<cfset var injector = createInjector() />
	<cfset var beanId = "" />
	<cfset var beanVars = "" />
	
	<cfset injector.injectBeanByMetadata(bean) />
	
	<cfset beanVars = bean._modelGlueBeanInjection_getVariablesScope() />
	
	<cfset assertTrue(structKeyExists(beanVars, "beans"), "'beans' struct not created") />
	<cfset assertTrue(structKeyExists(beanVars.beans, "bean"), "'bean' not in 'beans' scope") />
	<cfset assertTrue(isObject(beanVars.beans.bean), "'bean' in 'beans' not object") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean", "'bean' in 'beans' not right type!") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean2).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean2", "'bean2' in 'beans' not right type!") />
</cffunction>

<!---
Note: the inject() method for the coldspring injector _also_ performs old-school autowiring via autowire()

It's not anticipated that if a new ioc framework comes along that we'd support autowiring for it
--->
<cffunction name="testAutowiring" output="false" returntype="void" access="public">
	<cfset var bean = createTargetBean() />
	<cfset var injector = createInjector() />
	<cfset var beanVars = "" />
	
	<cfset injector.autowire(bean) />
	<cfset injector.createInjectionHooks(bean) />
	
	<cfset beanVars = bean._modelGlueBeanInjection_getVariablesScope() />
	
	<cfset assertTrue(structKeyExists(beanVars, "_bean"), "'_bean' not in variables scope") />
	<cfset assertTrue(isObject(beanVars._bean), "'_bean' not object") />
	<cfset assertTrue(getMetadata(beanVars._bean).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean", "'bean' in variables scope not right type!") />
	<cfset assertTrue(getMetadata(beanVars._bean2).name eq "ModelGlue.gesture.externaladapters.beaninjection.test.Bean2", "'bean2' in variables scope not right type!") />
</cffunction>

</cfcomponent>
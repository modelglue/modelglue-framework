<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfcomponent extends="mxunit.framework.TestCase">

<cfset createBeanFactory() />

<cffunction name="createInjector" output="false" access="public">
	<cfreturn createBeanFactory().getBean("injector") />
</cffunction>

<cffunction name="createBeanFactory" output="false" access="public">
	<cfset variables.bf = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset variables.bf.loadBeans(expandPath("/modelgluetests/unittests/gesture/externaladapters/beaninjection/ColdSpring.xml")) />
	
	<cfreturn variables.bf />
</cffunction>

<cffunction name="createTargetBean" output="false">
	<cfreturn createObject("component", "modelgluetests.unittests.gesture.externaladapters.beaninjection.Target") />
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
	<cfset assertTrue(getMetadata(beanVars.beans.bean).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean", "'bean' in 'beans' not right type!") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean2).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean2", "'bean2' in 'beans' not right type!") />
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
	<cfset assertTrue(getMetadata(beanVars.beans.bean).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean", "'bean' in 'beans' not right type!") />
	<cfset assertTrue(getMetadata(beanVars.beans.bean2).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean2", "'bean2' in 'beans' not right type!") />
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
	<cfset assertTrue(getMetadata(beanVars._bean).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean", "'bean' in variables scope not right type!") />
	<cfset assertTrue(getMetadata(beanVars._bean2).name eq "modelgluetests.unittests.gesture.externaladapters.beaninjection.Bean2", "'bean2' in variables scope not right type!") />
</cffunction>

</cfcomponent>

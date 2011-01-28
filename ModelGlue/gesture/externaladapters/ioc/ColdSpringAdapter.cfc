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


<cfcomponent output="false" hint="Provides a common interface for ModelGlue to add bean definitions and request bean instances.  The implementation is targeted towards using ColdSpring.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setBeanFactory" output="false" hint="Bean-factory-aware implementation" access="public">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" />
	
	<cfset variables._beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="loadBeanDefinitionsFromFile" output="false" hint="Adds additional bean definitions from a file." access="public">
	<cfargument name="filename" type="string" hint="Filename containing bean definitions." />
	
	<cfset variables._beanFactory.loadBeans(expandPath(arguments.filename)) />
</cffunction>

<cffunction name="getBean" output="false" hint="Gets a bean by Id." access="public">
	<cfargument name="beanId" type="string" hint="Bean Id (ID attribute of the relevant <BEAN> tag)." />
	
	<cfreturn variables._beanFactory.getBean(arguments.beanId) />
</cffunction>

<cffunction name="beanDefinitionExists" access="public" returntype="boolean" output="false"
			hint="searches all known factories (parents) to see if bean definition for the specified bean exists">
	<cfargument name="beanName" type="string" required="true" />
	<cfreturn variables._beanFactory.beanDefinitionExists( arguments.beanName ) />
</cffunction>
</cfcomponent>

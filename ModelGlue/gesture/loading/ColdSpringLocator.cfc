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


<cfcomponent output="false" hint="I can be used to get the Coldspring bean factory out of Model-Glue.">

	<cfproperty name="ModelGlue_APP_KEY" type="any" hint="The Coldspring bean factory." />

	<cffunction name="init" output="false" returntype="any" hint="Creates an instance of the ColdspringLocator.">
		<cfargument name="ModelGlue_APP_KEY" required="true" hint="The key in the Application scope in which Model-Glue is stored." />
	
		<cfset variables.ModelGlue_APP_KEY = arguments.ModelGlue_APP_KEY />
		
		<cfreturn this />
	
	</cffunction>
	
	<cffunction name="getBeanFactory" output="false" returntype="any" hint="Returns the Coldspring bean factory.">
	
		<cfreturn application[variables.ModelGlue_APP_KEY].getInternalBeanFactory() />
	
	</cffunction>
	
	<cffunction name="getBean" output="false" returntype="any" hint="Returns a bean from the Coldspring bean factory.">
		<cfargument name="beanId" required="true" hint="The Id of the bean in Coldspring." />
	
		<cfreturn application[variables.ModelGlue_APP_KEY].getBean(arguments.beanId) />
	
	</cffunction>
	
</cfcomponent>

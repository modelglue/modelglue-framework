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


<cfcomponent output="false" hint="Replaces createObject() for creating transient CFC instances and wiring in a getService() function.">

<cffunction name="init" output="false">
	<cfargument name="serviceLocator" />
	<cfset variables.serviceLocator = arguments.serviceLocator />
</cffunction>

<cffunction name="new" output="false">
	<cfargument name="cfcname" />
	<cfargument name="constructorArgs" default="#structNew()#" />
	
	<cfset var instance = createObject("component", arguments.cfcname) />
	<cfset var variablesScope = "" />
	
	<cfset instance._objectFactory_injectServiceLocator = this.injectServiceLocator />
	<cfset instance._objectFactory_getVariablesScope = this.getVariablesScope />
	
	<cfset variablesScope = instance._objectFactory_getVariablesScope() />
	
	<cfset variablesScope.getService = this.getService />
	
	<cfset instance._objectFactory_injectServiceLocator(variables.serviceLocator) />
	
	<cfset instance.init(argumentCollection=arguments.constructorArgs) />
	
	<cfreturn instance />
</cffunction>

<cffunction name="injectServiceLocator" output="false">
	<cfargument name="serviceLocator" />
	<cfset variables.serviceLocator = arguments.serviceLocator />
</cffunction>

<cffunction name="getService" output="false">
	<cfargument name="name" />
	<cfreturn variables.serviceLocator.getService(arguments.name) />
</cffunction>

<cffunction name="getVariablesScope" hint="Method template to get a target's variables scope.">
	<cfreturn variables />
</cffunction>

</cfcomponent>

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


<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="loadFrameworkIntoScope" output="false" hint="I get the bootstrapper from the request scope and save the instance of Model-Glue into the application scope.">
	<cfargument name="event" />

	<cfset var mg = "" />
	<cfset var boot = "" />

	<cfif request._modelglue.bootstrap.initializationRequest>
		<cfset mg = request._modelglue.bootstrap.framework />
		<cfset boot = request._modelglue.bootstrap.bootstrapper />
		
		<cfset application[boot.applicationKey] = mg />
	</cfif>

</cffunction>

<cffunction name="loadHelpers" output="false" hint="I load helpers.">
	<cfset var inj = beans.modelglueHelperInjector />
	<cfset var mg = getModelGlue() />
	<cfset var mappings = mg.getConfigSetting("helperMappings") />
	<cfset var mapping = "" />
	<cfloop list="#mappings#" index="mapping">
		<cfset inj.injectPath(mg.helpers, mapping) />
	</cfloop>
</cffunction>

</cfcomponent>

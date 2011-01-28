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

<cffunction name="appendGeneratedViewMapping" output="false" access="public" returntype="void" hint="I append the generatedViewMapping to the viewMappings if needed">
	<cfargument name="event" />
	<cfset var i = 0 />
	<cfset var _modelglue = GetModelGlue() />
	<cfset var generatedViewMapping = _modelglue.getConfigSetting("generatedViewMapping") />
	
	<!--- Note: We operate directly on the viewMappings array in _modelglue.configuration to save from reading a copy and writing it back --->
	
	<!--- Check to see if the generatedViewMapping already appears in the viewMappings --->
	<cfloop index="i" from="1" to="#ArrayLen(_modelglue.configuration.viewMappings)#">
		<cfif _modelglue.configuration.viewMappings[i] eq generatedViewMapping>
			<!--- Found an existing view mapping for generatedViewMapping --->
			<cfreturn />
		</cfif>
	</cfloop>
	
	<!--- We don't have a view mapping for the generated views, so append it to the array --->
	<cfset ArrayAppend(_modelglue.configuration.viewMappings, generatedViewMapping) />
	
</cffunction>

<cffunction name="generateScaffolds" output="false" access="public" returntype="void" hint="">
	<cfargument name="event">
	
	<cfset var moduleLoaderArray = getModelGlue().getModuleLoaderArray() />
	<cfset var moduleIndex = 0 />
	<cfset var moduleLoader = "" />
	<cfset var scaffolds = arrayNew(1) />
	
	<cfif getModelGlue().getConfigSetting("reload") is true and getModelGlue().getConfigSetting("rescaffold") is true>
		<cfloop from="1" to="#arrayLen(moduleLoaderArray)#" index="moduleIndex">
			<cfset moduleLoader = moduleLoaderArray[moduleIndex] />
			
			<cfset moduleLoader.loadScaffolds(getModelGlue()) />
		</cfloop>
	</cfif>
</cffunction>

</cfcomponent>

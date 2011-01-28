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


<cfcomponent output="false" extends="ModelGlue.gesture.eventrequest.EventRequestPhase"
						 hint="Abstract of an execution phase that loads modules."
>
	
<cffunction name="init" output="false">
	<cfargument name="moduleLoaderFactory" require="true" hint="I am the factory through which module loaders may be attained." />
	<cfargument name="modules" type="array" required="true" hint="I am the list of XML modules to load as part of this phase." />
	
	<cfset variables._moduleLoaderFactory = arguments.moduleLoaderFactory />
	<cfset variables._modules = arguments.modules />	
</cffunction>

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	
	<cfset loadModules(arguments.eventContext.getModelGlue()) />
</cffunction>

<cffunction name="loadModules" access="private" output="false" hint="Loads modules associated with this phase.">
	<cfargument name="modelglue" />
	
	<cfset var i = "" />
	
	<cfloop from="1" to="#arrayLen(variables._modules)#" index="i">
		<cfset variables._moduleLoaderFactory.create("XML").load(modelglue, variables._modules[i]) />
	</cfloop>
</cffunction>

</cfcomponent>

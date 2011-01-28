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

<cffunction name="loadInitialXMLModule" output="false" hint="I get the bootstrapper from the request scope and loads the initial module.">
	<cfargument name="event" />
	
	<cfset var mg = "" />
	<cfset var loader = "" />
	<cfset var loadedModules = structNew() />
	
	<!--- If we have a case of someone loading MG w/o their own XML file, consider empty string as an already-loaded module. --->
	<cfset loadedModules[""] = true >
	
	<cfset arguments.event.addTraceStatement("Configuration", "Loading Initial XML Module") />
	<cfset mg = getModelGlue() />
	
	<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />
	
	<cfset loader.load(mg, mg.getConfigSetting("primaryModule"), loadedModules) />
	<cfset this.loaded = true />
</cffunction>

<cffunction name="configureCache" output="false" hint="I configure default timeout for the cache adapter.">
	<cfargument name="event" />
	
	<cfset var mg = getModelGlue() />
	<cfset var cacheAdapter = mg.cacheAdapter />
	<cfset var defaultCacheTimeout = mg.getConfigSetting("defaultCacheTimeout") />

	<cfset cacheAdapter.setDefaultTimeout(defaultCacheTimeout) />
</cffunction>

</cfcomponent>

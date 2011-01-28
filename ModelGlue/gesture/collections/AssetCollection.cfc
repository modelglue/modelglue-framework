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


<cfcomponent displayName="AssetCollection" output="false" hint="I am a collection of CSS/JS assets.">

<cffunction name="init" output="false" returntype="any" hint="I build a new AssetCollection.">
	<cfargument name="event" />
	<cfset variables.event = arguments.event />
	<cfset variables.assetsRendered = false />
	
	<cfset variables.CSSAssets = arrayNew(1) />
	<cfset variables.JSAssets = arrayNew(1) />
	
	<cfset variables.assetPaths = structNew() />
	
	<cfreturn this />
</cffunction>


<!--- Dependencies --->
<cffunction name="setAssetManager" output="false" returntype="void">
	<cfargument name="assetManager" type="any" required="true" />
	
	<cfset variables.assetManager = arguments.assetManager />
</cffunction>


<!--- Methods --->
<cffunction name="addAssetCode" output="false" returntype="void" hint="Adds an asset code block for the request.">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="code" type="string" required="true" />
	<cfargument name="name" type="string" required="false" />
	
	<cfset arrayAppend(variables["#arguments.type#Assets"], arguments.code) />
</cffunction>

<cffunction name="addAssetFile" output="false" returntype="void" hint="Adds an asset file path for the request.">
	<cfargument name="type" type="string" required="true" />
	<cfargument name="path" type="string" required="true" />
	<cfargument name="name" type="string" required="false" />
	<cfargument name="ieOnly" type="boolean" required="false" />

	<cfset arguments.event = variables.event />
		
	<cfif not structKeyExists(variables.assetPaths, arguments.path)>
		<cfset structInsert(variables.assetPaths, arguments.path, arguments.path) />
		<cfset arrayAppend(variables["#arguments.type#Assets"], variables.assetManager.getAssetFileTag(argumentCollection=arguments)) />
	</cfif>
</cffunction>

<cffunction name="assetsRendered" output="false" returntype="boolean" hint="Returns a flag indicating whether assets have been rendered for the request.">
	<cfreturn variables.assetsRendered />
</cffunction>

<cffunction name="getCSSAssets" output="false" returntype="string" hint="Returns a string containing all CSS assets for the request.">
	<cfset variables.assetsRendered = true />
	
	<cfreturn arrayToList(variables.CSSAssets, "") />
</cffunction>

<cffunction name="getJSAssets" output="false" returntype="string" hint="Returns a string containing all JS assets for the request.">
	<cfset variables.assetsRendered = true />
	
	<cfreturn arrayToList(variables.JSAssets, "") />
</cffunction>

<cffunction name="getAllAssets" output="false" returntype="string" hint="Returns a string containing all assets for the request.">
	<cfreturn getCSSAssets() & getJSAssets() />
</cffunction>

<cffunction name="renderAssetsInHead" output="false" returntype="void" hint="Renders all assets for the request using <cfhtmlhead>.">
	<cfset variables.assetManager.renderAssetsInHead(getAllAssets()) />
</cffunction>

</cfcomponent>

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


<cfcomponent output="false" extends="ModelGlue.gesture.ModelGlue"
	hint="The core of the Model-Glue framework.  Extends the MG3 ModelGlue.cfc and adds memoization.">

<cfset variables.ModuleLoaderArray = arrayNew(1) />

<cffunction name="getController" output="false" returntype="any" hint="Gets a controller by id.">
	<cfargument name="controllerID" type="string" />
	
	<cfset var NumberOfLoaders = arrayLen( variables.ModuleLoaderArray ) />
	<cfset var i = "" />
	
	<cfif structKeyExists( this.controllers, arguments.controllerID ) IS false AND controllerWasDefined( arguments.controllerId ) IS true>
		<cfloop from="1" to="#NumberOfLoaders#" index="i">
			<cfset variables.ModuleLoaderArray[ i ].locateAndMakeController( this, arguments.controllerID ) />
		</cfloop>
	</cfif>	

	<cfreturn this.controllers[arguments.controllerId] />
</cffunction>


<cffunction name="controllerIsAlreadyLoaded" output="false" returntype="boolean" hint="I look for a specific controller in the Model Glue scope">
	<cfargument name="controllerID" type="string" required="true"/>
	
	<cfreturn structKeyExists( this.controllers, arguments.controllerID ) />
</cffunction>

<cffunction name="controllerWasDefined" output="false" access="private" returntype="boolean" hint="I look for a specific controller in the registered module loaders">
	<cfargument name="controllerID" type="string" required="true"/>
	
	<cfset var NumberOfLoaders = arrayLen( variables.ModuleLoaderArray ) />
	<cfset var i = "" />
	
	<!--- Try to find the controller definition in the registered modules --->
	<cfloop from="1" to="#NumberOfLoaders#" index="i">
		<cfif variables.ModuleLoaderArray[ i ].hasControllerDefinition( arguments.controllerID ) IS true>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<cffunction name="getEventHandler" output="false" hint="I get an event handler by name.  If one doesn't exist, a struct key not found error is thrown - this is a heavy hit method, so it's about speed, not being nice.">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler to return." />
	
	<cfset var NumberOfLoaders = arrayLen( variables.ModuleLoaderArray ) />
	<cfset var i = "" />
	
	<cfif structKeyExists( this.eventHandlers, arguments.eventHandlerName ) IS false AND eventHandlerWasDefined( arguments.eventHandlerName ) IS true>
		<cfloop from="1" to="#NumberOfLoaders#" index="i">
			<cfset variables.ModuleLoaderArray[ i ].locateAndMakeEventHandler( this, arguments.eventHandlerName ) />
		</cfloop>
	</cfif>
	
	<cfreturn this.eventHandlers[arguments.eventHandlerName] />
</cffunction>

<cffunction name="hasEventHandler" output="false" hint="Does an event handler by the given name exist?">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler in question." />
	
	<cfset var NumberOfLoaders = arrayLen( variables.ModuleLoaderArray ) />
	<cfset var i = "" />
	
	<!--- Try to find the event handler definition in the registered modules  --->
	<cfloop from="1" to="#NumberOfLoaders#" index="i">
		<cfif variables.ModuleLoaderArray[ i ].hasEventHandlerDefinition( arguments.eventHandlerName ) IS true>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<cffunction name="eventHandlerWasDefined" output="false" hint="Does an event handler by the given name exist?">
	<cfargument name="eventHandlerName" type="string" required="true" hint="The event handler in question." />
	
	<cfset var NumberOfLoaders = arrayLen( variables.ModuleLoaderArray ) />
	<cfset var i = "" />
	
	<!--- Try to find the event handler definition in the registered modules --->
	<cfloop from="1" to="#NumberOfLoaders#" index="i">
		<cfif variables.ModuleLoaderArray[ i ].hasEventHandlerDefinition( arguments.eventHandlerName ) IS true>
			<cfreturn true />
		</cfif>
	</cfloop>
	
	<cfreturn false />
</cffunction>

<!--- EVENT TYPE MANAGEMENT --->
<cffunction name="addEventType" output="false" returntype="void" hint="I add an event type.">
	<cfargument name="eventTypeName" type="string" required="true" hint="The event type to add." />
	<cfargument name="eventType" type="struct" required="true" hint="The event type to add." />
	
	<cfset this.eventTypes[arguments.eventTypeName] = arguments.eventType />
</cffunction>

<cffunction name="getEventType" output="false" hint="I get an event type by name.">
	<cfargument name="eventTypeName" type="string" required="true" hint="The event type to return." />
	
	<cfreturn this.eventTypes[arguments.eventTypeName] />
</cffunction>

<cffunction name="hasEventType" output="false" hint="Does an event type by the given name exist?">
	<cfargument name="eventTypeName" type="string" required="true" hint="The event type in question." />
	
	<cfreturn structKeyExists(this.eventTypes, arguments.eventTypeName) />
</cffunction>

<cffunction name="getModuleLoaderArray" output="false" access="public" returntype="array" hint="I return the configuration array of module loaders">
	<cfreturn variables.ModuleLoaderArray />
</cffunction>

<cffunction name="addModuleLoader" output="false" access="public" returntype="void" hint="I add a module loader to the internal store">
	<cfargument name="ModuleLoader" type="any" required="true"/>
	
	<cfset arrayAppend( variables.ModuleLoaderArray, arguments.ModuleLoader ) />
</cffunction>

<cffunction name="reset" output="false" access="public" returntype="void" hint="I reset the state of Model-Glue to perform a 'soft' reload">
	<cfset var index = 0 />
	
	<cfset structClear(this.messageListeners) />
	<cfset structClear(this.controllers) />
	<cfset structClear(this.eventHandlers) />
	<cfset structClear(this.eventTypes) />
	
	<cfloop from="1" to="#arrayLen(this.phases)#" index="index">
		<cfset this.phases[index].loaded = false />
	</cfloop>
	
	<cfloop from="1" to="#arrayLen(variables.ModuleLoaderArray)#" index="index">
		<cfset variables.ModuleLoaderArray[index].clearConfig() />
	</cfloop>
</cffunction>

</cfcomponent>

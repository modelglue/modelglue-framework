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


<cfcomponent displayName="ViewRenderer" output="false" hint="I am responsible for rendering views.">

<cffunction name="init" access="public" returnType="any" output="false" hint="I build a new view renderer.">
  <!--- use this struct to cache where different view files are located. --->
  <cfset variables.cachedViewLocations = {}/>
  
  <cfreturn this />
</cffunction>

<cffunction name="setModelGlue" output="false" hint="Sets the MG  instance to use.">
	<cfargument name="modelGlue" required="true" type="ModelGlue.gesture.ModelGlue" />
	
	<cfset variables._modelGlue = arguments.modelGlue />	

</cffunction>

<cffunction name="getViewMappings" output="false" hint="Gets the current list of view mappings.">
	<cfreturn variables._modelGlue.configuration.viewMappings  />
</cffunction>
<cffunction name="addViewMapping" output="false" hint="Adds a new view mapping.">
	<cfargument name="viewMapping" type="string" />
	<cfset var newViewMappingArray = arrayNew( 1 ) />
	<cfset arrayAppend( newViewMappingArray , arguments.viewMapping ) /> 
	<cfset variables._modelGlue.setConfigSetting( "viewMappings", newViewMappingArray ) >
</cffunction>

<cffunction name="renderView" output="false" hint="I render a view and return the resultant HTML.">
	<cfargument name="eventContext" type="any" hint="Event context in which this view is being rendered.">
	<cfargument name="view" type="any" hint="I am the view to render.">
	<cfargument name="helpers" hint="I am the ""helpers"" scope available within the view." default="#structNew()#" />

	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var includeFound = false />
	<cfset var template = "" />
	<cfset var result = "" />
	<cfset var _viewMappings = adviseArray( getViewMappings() , eventContext.getValue("viewMappingAdvice") ) />
	
	<cfloop collection="#arguments.view.values#" item="i">
	  <cfif arguments.view.values[i].overwrite or not arguments.eventContext.exists(i)>
		  <cfset arguments.eventContext.setValue(i, arguments.view.values[i].value) />
	  </cfif>
	</cfloop>

	<!--- first look in the cache to see if we've already found this view template. If so, use the path in the cache --->
	<cfif structKeyExists(variables.cachedViewLocations, arguments.view.template)>
		<cfset includeFound = true/>
		<cfset template = variables.cachedViewLocations[arguments.view.template]/>
	<cfelse>
		<!--- else it wasn't in the cache, so see if we can find it on disk in any of the view mapping directories --->
		<cfloop from="1" to="#arrayLen(_viewMappings)#" index="i">
			<cfset template = _viewMappings[i] & "/" & arguments.view.template />
			<cfif fileExists(expandPath(template))>
				<cfset includeFound = true />
				<!--- now that we've found it, cache it so we don't have to look for it next time --->
				<cfset variables.cachedViewLocations[arguments.view.template] = template />
				<cfbreak />
			</cfif>	
		</cfloop>
	</cfif>

	<cfif not includeFound>
		<cfthrow type="ViewRenderer.includeNotFound"
						 message="The template (#arguments.view.template#) was not found in any registered view mappings (#arrayToList(_viewMappings)#)." />
	</cfif>
	
	<cfsavecontent variable="result"><cfmodule template="/ModelGlue/gesture/view/ViewRenderer.cfm" includepath="#template#" viewstate="#arguments.eventContext#" viewcollection="#arguments.eventContext.getViewCollection()#" helpers="#arguments.helpers#"></cfsavecontent>
	
	<cfreturn result />
	<!---
	<cfset var result = "" />
	<cfset var v = "" />
	<cfset var i = "" />
	<cfset var viewstate = arguments.stateContainer />
	<cfset var viewCollection = arguments.viewCol />
  
  <cfloop collection="#arguments.StateValues#" item="i">
    <cfif arguments.StateValues[i].overwrite or not viewstate.exists(i)>
  	  <cfset viewstate.SetValue(i,arguments.StateValues[i].value) />
    </cfif>
  </cfloop>
  
  <cfsavecontent variable="result"><cfmodule template="/ModelGlue/unity/view/ViewRenderer.cfm" includepath="#arguments.includeUrl#" viewstate="#viewstate#" viewcollection="#viewcollection#"></cfsavecontent>

  <cfreturn result />
	--->
</cffunction>

<cffunction name="adviseArray" output="false" access="private" returntype="array" hint="I take any preferred values and put them at the beginning of the array">
	<cfargument name="baseArray" type="array" required="true" />
	<cfargument name="preferredValues" type="string" default="" />
	<cfif len( trim( arguments.preferredValues ) ) IS 0>
		<cfreturn arguments.baseArray />
	</cfif>
	<cfreturn listToArray( listPrepend( arrayToList( arguments.baseArray ), arguments.preferredValues ) ) />
</cffunction>

</cfcomponent>

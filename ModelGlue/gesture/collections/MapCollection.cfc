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


<cfcomponent displayname="MapCollection" output="false" hint="I am a generic collection of key/value pairs.">

<cffunction name="init" access="public" returnType="MapCollection" output="false" hint="I build a new MapCollection.">
	<cfargument name="values" required="false" default="#arrayNew(1)#" hint="A single structure or array of structure to merge into this collection." />

  	<cfset var i = "" />
	<cfset var tmp = "" />
	
	<cfif isStruct(values)>
		<cfset tmp = arguments.values />
		<cfset arguments.values = arrayNew(1) />
		<cfset arrayAppend(arguments.values, tmp) />
	<cfelseif not isArray(values)>
		<cfthrow type="ModelGlue.gesture.collections.MapCollection"
						 message="Invalid initial values type!" />
	</cfif>
	
  <cfset variables.values = structNew() />

  <cfloop to="#arrayLen(arguments.values)#" from="1" index="i">
    <cfset merge(arguments.values[i]) />
  </cfloop>
  
  <cfreturn this />
</cffunction>

<cffunction name="getAll" access="public" returnType="struct" output="false" hint="I get all values by reference.">
  <cfreturn variables.values />
</cffunction>

<cffunction name="setValue" access="public" returnType="void" output="false" hint="I set a value in the collection.">
  <cfargument name="name" hint="I am the name of the value.">
  <cfargument name="value" hint="I am the value.">

  <cfset variables.values[arguments.name] = arguments.value />
</cffunction>

<cffunction name="getValue" access="public" returnType="any" output="false" hint="I get a value from the collection.">
  <cfargument name="name" hint="I am the name of the value.">
  <cfargument name="default" required="false" type="any" hint="I am a default value to set and return if the value does not exist." />

  <cfif exists(arguments.name)>
    <cfreturn variables.values[arguments.name] />
  <cfelseif structKeyExists(arguments, "default")>
    <cfset setValue(arguments.name, arguments.default) />
    <cfreturn arguments.default />
  <cfelse>
    <cfreturn "" />
  </cfif>
</cffunction>

<cffunction name="removeValue" access="public" returnType="void" output="false" hint="I remove a value from the collection.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
	
	<cfif exists(arguments.name)>
	  <cfset structDelete(variables.values, arguments.name) />
	</cfif>
</cffunction>

<cffunction name="exists" access="public" returnType="boolean" output="false" hint="I state if a value exists.">
  <cfargument name="name" type="string" required="true" hint="I am the name of the value.">
  <cfreturn structKeyExists(variables.values, arguments.name)>
</cffunction>

<cffunction name="merge" access="public" returnType="void" output="false" hint="I merge an entire struct into the collection.">
  <cfargument name="struct" type="struct" required="true" hint="I am the struct to merge." />
  
  <cfset var i = "" />
  
  <cfloop collection="#arguments.struct#" item="i">
    <cfset setValue(i, arguments.struct[i]) />
  </cfloop>
</cffunction>

</cfcomponent>

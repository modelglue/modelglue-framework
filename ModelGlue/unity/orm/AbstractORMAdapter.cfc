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


<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="AbstractORMAdapter.cfc" hint="I am a marker for Model-Glue ORM adapters.">

<cffunction name="init" returntype="ModelGlue.unity.orm.AbstractORMAdapter" output="false" access="public">
	<cfargument name="ormName" type="any" required="false" default="Abstract" />
	<cfset variables._ormName = arguments.ormName />
	<cfreturn this />
</cffunction>

<cffunction name="getObjectMetadata" returntype="struct" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfreturn createObject("component", "ModelGlue.unity.orm.ObjectMetadata").init() />
</cffunction>

<cffunction name="getCriteriaProperties" returntype="string" output="false" access="public">
	<cfreturn "" />
</cffunction>

<cffunction name="list" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="criteria" type="struct" required="false" />
	<cfargument name="orderColumn" type="string" required="false" />
	<cfargument name="orderAscending" type="boolean" required="false" default="true" />
	<cfargument name="gatewayMethod" type="string" required="false" />
	<cfargument name="gatewayBean" type="string" required="false" />
</cffunction>

<cffunction name="new" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
</cffunction>

<cffunction name="read" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
</cffunction>

<cffunction name="validate" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="string" required="true" />
</cffunction>

<cffunction name="assemble" returntype="any" output="false" access="public">
	<cfargument name="eventContext" type="ModelGlue.unity.eventrequest.EventContext" required="true" />
	<cfargument name="target" type="any" required="true" />
</cffunction>

<cffunction name="commit" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="record" type="string" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
</cffunction>

<cffunction name="delete" returntype="any" output="false" access="public">
	<cfargument name="table" type="string" required="true" />
	<cfargument name="primaryKeys" type="struct" required="true" />
	<cfargument name="useTransaction" type="any" required="false" default="true" />
</cffunction>

<!--- Note: This determineLabel function is implemented in ReactorAdapter.cfc, TransferAdapter.cfc and TransferDictionary.cfc
	all with the exact same implementation.
	It really should be removed from the other adapters and simply inherited from here.
--->

<cffunction name="determineLabel" returntype="string" output="false" access="private">
	<cfargument name="label" type="string" required="true" />
	
	<cfset var i = "" />
	<cfset var char = "" />
	<cfset var result = "" />
	
	<cfloop from="1" to="#len(arguments.label)#" index="i">
		<cfset char = mid(arguments.label, i, 1) />
		
		<cfif i eq 1>
			<cfset result = result & ucase(char) />
		<cfelseif asc(lCase(char)) neq asc(char)>
			<cfset result = result & " " & ucase(char) />
		<cfelse>
			<cfset result = result & char />
		</cfif>
	</cfloop>

	<cfreturn result />	
</cffunction>

<cffunction name="getOrmName" returntype="string" output="false" access="public">
	<cfreturn variables._ormName />
</cffunction>

<cffunction name="getSourceValue" output="false" access="public" returntype="any" hint="Used by templates generated via scaffolding">
	<cfargument name="record" required="true" />
	<cfargument name="propertyName" required="true" />
	<cfargument name="sourceKey" required="true" />
	<cfargument name="event" required="false" />
	<cfset var sourceValue = "" />
	<cfif structKeyExists(arguments,"event") and arguments.event.valueExists(arguments.sourceKey)>
		<cfset sourceValue = arguments.event.getValue(arguments.sourceKey) />
	<cfelse>
		<cftry>
			<!--- note that only Transfer differs from this logic, so the default is implemented here, and it's overridden in the Transfer adapter --->
			<cfset sourceValue = evaluate("arguments.record.get#arguments.propertyName#()") />
			<cfcatch>
			</cfcatch>
		</cftry>
		<cfif isDefined("sourceValue") and isObject(sourceValue)>
			<cfset sourceValue = evaluate("sourceValue.get#arguments.sourceKey#()") />
		<cfelse>
			<cfset sourceValue = "" />
		</cfif>
	</cfif>
	<cfreturn sourceValue />
</cffunction>

<cffunction name="getSelectedList" output="false" access="public" returntype="any" hint="Used by templates generated via scaffolding">
	<cfargument name="event" required="true" />
	<cfargument name="record" required="true" />
	<cfargument name="propertyName" required="true" />
	<cfargument name="sourceKey" required="true" />
	
	<cfset var selectedList = "" />
	<cfset var selected = "" />
	<cfset var i = "" />

	<cfif arguments.event.exists(arguments.propertyName & "|" & arguments.sourceKey)>
		<cfset variables.selectedList = event.getValue(arguments.propertyName & "|" & arguments.sourceKey) />
	<cfelse>
		<cfset selected = getChildCollection(arguments.record,arguments.propertyName) />
		<cfif isQuery(selected)>
			<cfset selectedList = evaluate("valueList(selected.#arguments.sourceKey#)") />
		<cfelseif isStruct(selected)>
			<cfset selectedList = "" />
			<cfloop collection="#selected#" item="i">
				<cfset selectedList = listAppend(selectedList, evaluate("selected[i].get#arguments.sourceKey#()")) />
			</cfloop>
		<cfelseif isArray(selected)>
			<cfset selectedList = "" />
			<cfloop from="1" to="#arrayLen(selected)#" index="i">
				<cfset selectedList = listAppend(selectedList, evaluate("selected[i].get#arguments.sourceKey#()")) />
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn selectedList />
</cffunction>

<cffunction name="getChildCollection" output="false" access="public" returntype="any" hint="Used by templates generated via scaffolding">
	<cfargument name="record" required="true" />
	<cfargument name="propertyName" required="true" />
	
	<cfset var theCollection = "" />
	
	<!--- TODO: This needs to be factored out into the respective ORM adapters. For now it only exists in the Abstract adapter. --->
	<!--- This should support both transfer and reactor. Add more ORM specific stuff here --->
	<cfif structKeyExists(arguments.record, "get#arguments.propertyName#Struct")>
		<cfset theCollection = evaluate("arguments.record.get#arguments.propertyName#Struct()") />
	<cfelseif structKeyExists(arguments.record, "get#arguments.propertyName#Array")>
		<cfset theCollection = evaluate("arguments.record.get#arguments.propertyName#Array()") />
	<cfelseif structKeyExists(arguments.record, "get#arguments.propertyName#Iterator")>
		<cfset theCollection = evaluate("arguments.record.get#arguments.propertyName#Iterator().getQuery()") />
	<cfelse>
		<!--- cfOrm --->
		<cfset theCollection = evaluate("arguments.record.get#arguments.propertyName#()") />
	</cfif>

	<!--- Added isDefined check to support cfOrm --->
	<cfif not isDefined("theCollection")>
		<cfset theCollection = "" />
	</cfif>

	<cfreturn theCollection />
</cffunction>

</cfcomponent>

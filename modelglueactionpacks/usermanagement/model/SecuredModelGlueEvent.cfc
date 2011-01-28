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



<cfcomponent displayname="SecuredModelGlueEvent" output="false">
		<cfproperty name="EventId" type="numeric" default="" />
		<cfproperty name="Name" type="string" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" output="false">
		<cfargument name="EventId" type="string" required="false" default="0" />
		<cfargument name="Name" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setEventId(arguments.EventId) />
		<cfset setName(arguments.Name) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="any" output="false">
		<cfset var errors = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
		<cfset var thisError = structNew() />
		
		<!--- EventId --->
		<cfif (len(trim(getEventId())) AND NOT isNumeric(trim(getEventId())))>
			<cfset errors.addError("EventId", "EventId must be a number.") />
		</cfif>
		
		<!--- Name --->
		<cfif (NOT len(trim(getName())))>
			<cfset errors.addError("Name", "Name is required.") />
		</cfif>
		<cfif (len(trim(getName())) AND NOT IsSimpleValue(trim(getName())))>
			<cfset errors.addError("Name", "Name must be a simple value.") />
		</cfif>
		<cfif (len(trim(getName())) GT 500)>
			<cfset errors.addError("Name", "Name must be 500 characters or less.") />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setEventId" access="public" returntype="void" output="false">
		<cfargument name="EventId" type="string" required="true" />
		<cfset variables.instance.EventId = arguments.EventId />
	</cffunction>
	<cffunction name="getEventId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.EventId />
	</cffunction>

	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="Name" type="string" required="true" />
		<cfset variables.instance.Name = arguments.Name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Name />
	</cffunction>


	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>


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

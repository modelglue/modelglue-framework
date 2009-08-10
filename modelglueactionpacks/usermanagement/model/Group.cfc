
<cfcomponent displayname="Group" output="false">
		<cfproperty name="GroupId" type="numeric" default="0" />
		<cfproperty name="Name" type="string" default="" />
		<cfproperty name="Description" type="string" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="modelglueactionpacks.usermanagement.model.Group" output="false">
		<cfargument name="GroupId" type="string" required="false" default="0" />
		<cfargument name="Name" type="string" required="false" default="" />
		<cfargument name="Description" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setGroupId(arguments.GroupId) />
		<cfset setName(arguments.Name) />
		<cfset setDescription(arguments.Description) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="modelglueactionpacks.usermanagement.model.Group" output="false">
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
		
		<!--- GroupId --->
		<cfif (len(trim(getGroupId())) AND NOT isNumeric(trim(getGroupId())))>
			<cfset errors.addError("GroupId", "GroupId must be a number.") />
		</cfif>
		
		<!--- Name --->
		<cfif (NOT len(trim(getName())))>
			<cfset errors.addError("Name", "Name is required.") />
		</cfif>
		<cfif (len(trim(getName())) AND NOT IsSimpleValue(trim(getName())))>
			<cfset errors.addError("Name", "Name must be a simple value.") />
		</cfif>
		<cfif (len(trim(getName())) GT 50)>
			<cfset errors.addError("Name", "Name must be 50 characters or less.") />
		</cfif>
		
		<!--- Description --->
		<cfif (len(trim(getDescription())) AND NOT IsSimpleValue(trim(getDescription())))>
			<cfset errors.addError("Description", "Description must be a simple value.") />
		</cfif>
		<cfif (len(trim(getDescription())) GT 100)>
			<cfset errors.addError("Description", "Description must be 100 characters or less.") />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setGroupId" access="public" returntype="void" output="false">
		<cfargument name="GroupId" type="string" required="true" />
		<cfset variables.instance.GroupId = arguments.GroupId />
	</cffunction>
	<cffunction name="getGroupId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.GroupId />
	</cffunction>

	<cffunction name="setName" access="public" returntype="void" output="false">
		<cfargument name="Name" type="string" required="true" />
		<cfset variables.instance.Name = arguments.Name />
	</cffunction>
	<cffunction name="getName" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Name />
	</cffunction>

	<cffunction name="setDescription" access="public" returntype="void" output="false">
		<cfargument name="Description" type="string" required="true" />
		<cfset variables.instance.Description = arguments.Description />
	</cffunction>
	<cffunction name="getDescription" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Description />
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

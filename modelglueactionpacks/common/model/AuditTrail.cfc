
<cfcomponent displayname="AuditTrail" output="false">
		<cfproperty name="createdOn" type="date" default="" />
		<cfproperty name="updatedOn" type="date" default="" />
		<cfproperty name="createdBy" type="any" default="" />
		<cfproperty name="updatedBy" type="any" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="createdOn" type="string" required="false" default="" />
		<cfargument name="updatedOn" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setcreatedOn(arguments.createdOn) />
		<cfset setupdatedOn(arguments.updatedOn) />
		<cfset setcreatedBy(getService("objectFactory").new("modelglueactionpacks.usermanagement.model.User")) />
		<cfset setupdatedBy(getService("objectFactory").new("modelglueactionpacks.usermanagement.model.User")) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="modelglueactionpacks.wiki.model.WikiPage" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="any" output="false">
		<cfargument name="errors" default="#createObject("component", "ModelGlue.Util.ValidationErrorCollection").init()#" />
		<cfset var thisError = structNew() />
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
<cffunction name="setcreatedOn" access="public" returntype="void" output="false">
		<cfargument name="createdOn" type="string" required="true" />
		<cfset variables.instance.createdOn = arguments.createdOn />
	</cffunction>
	<cffunction name="getcreatedOn" access="public" returntype="string" output="false">
		<cfreturn variables.instance.createdOn />
	</cffunction>

	<cffunction name="setupdatedOn" access="public" returntype="void" output="false">
		<cfargument name="updatedOn" type="string" required="true" />
		<cfset variables.instance.updatedOn = arguments.updatedOn />
	</cffunction>
	<cffunction name="getupdatedOn" access="public" returntype="string" output="false">
		<cfreturn variables.instance.updatedOn />
	</cffunction>

	<cffunction name="setcreatedBy" access="public" returntype="void" output="false">
		<cfargument name="createdBy" type="any" required="true" />
		<cfset variables.instance.createdBy = arguments.createdBy />
	</cffunction>
	<cffunction name="getcreatedBy" access="public" returntype="any" output="false">
		<cfreturn variables.instance.createdBy />
	</cffunction>

	<cffunction name="setupdatedBy" access="public" returntype="void" output="false">
		<cfargument name="updatedBy" type="any" required="true" />
		<cfset variables.instance.updatedBy = arguments.updatedBy />
	</cffunction>
	<cffunction name="getupdatedBy" access="public" returntype="any" output="false">
		<cfreturn variables.instance.updatedBy />
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

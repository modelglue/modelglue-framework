<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="onRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("onRequestStart", "Internal onRequestStart invoked") />
</cffunction>

<cffunction name="customOnRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("customOnRequestStart", "Custom onRequestStart invoked") />
</cffunction>

</cfcomponent>
<cfcomponent output="false" hint="I am a Model-Glue controller." extends="modelglueactionpacks.usermanagement.controller.AbstractUserManagementController"
>

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>

	<cffunction name="onRequestStart" output="false">
		<cfargument name="event" />
		
		<cfset arguments.event.setValue("navigationSections", arrayNew(1)) />
	</cffunction>
</cfcomponent>
	

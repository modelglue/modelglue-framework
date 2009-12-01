<cfcomponent output="false" displayName="Status Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="StatusService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="statusGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.statusGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteStatuses" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteStatus(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getStatus" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getStatus(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "StatusBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getStatuses" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getStatuses()>
	</cffunction>

	<cffunction name="saveStatus" access="public" returnType="void" output="false">
		<cfargument name="status" type="any" required="true">
		<cfset variables.gateway.saveStatus(arguments.status)>
	</cffunction>
		
	
</cfcomponent>
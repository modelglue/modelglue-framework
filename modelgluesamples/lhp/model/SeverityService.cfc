<cfcomponent output="false" displayName="Severity Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="SeverityService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="severityGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.severityGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteSeverities" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteSeverity(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getSeverity" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getSeverity(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "SeverityBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getSeverities" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getSeverities()>
	</cffunction>

	<cffunction name="saveSeverity" access="public" returnType="void" output="false">
		<cfargument name="severity" type="any" required="true">
		<cfset variables.gateway.saveSeverity(arguments.severity)>
	</cffunction>
		
	
</cfcomponent>
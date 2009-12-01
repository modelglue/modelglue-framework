<cfcomponent output="false" displayName="Issue Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="IssueService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="issueGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.issueGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteIssue" access="public" returnType="void" output="false">
		<cfargument name="id" type="any" required="false">
		<cfset variables.gateway.deleteIssue(arguments.id)>
	</cffunction>
	
	<cffunction name="getIssue" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="false">
		<cfif structKeyExists(arguments,"id") and isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getIssue(arguments.id)>
		<cfelse>
			<cfreturn variables.gateway.newIssue()>
		</cfif>
	</cffunction>
		
	<cffunction name="getIssues" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getIssues(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="saveIssue" access="public" returnType="any" output="false">
		<cfargument name="issue" type="any" required="true">
		<cfreturn variables.gateway.saveIssue(arguments.issue)>
	</cffunction>
	
</cfcomponent>
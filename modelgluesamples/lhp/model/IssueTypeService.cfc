<cfcomponent output="false" displayName="Issue Type Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="IssueTypeService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="issueTypeGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.issueTypeGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteIssueTypes" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteIssueType(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getIssueType" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getIssueType(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "IssueTypeBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getIssueTypes" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getIssueTypes()>
	</cffunction>

	<cffunction name="saveIssueType" access="public" returnType="void" output="false">
		<cfargument name="issuetype" type="any" required="true">
		<cfset variables.gateway.saveIssueType(arguments.issuetype)>
	</cffunction>
			
</cfcomponent>
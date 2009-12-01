<cfcomponent output="false" displayName="Milestone Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="MilestoneService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="milestoneGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.milestoneGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteMilestones" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteMilestone(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getMilestone" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getMilestone(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "MilestoneBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getMilestones" access="public" returnType="query" output="false">
		<cfargument name="project" required="true" type="any">
		<cfreturn variables.gateway.getMilestones(project)>
	</cffunction>

	<cffunction name="saveMilestone" access="public" returnType="void" output="false">
		<cfargument name="milestone" type="any" required="true">
		<cfset variables.gateway.saveMilestone(arguments.milestone)>
	</cffunction>
		
	
</cfcomponent>
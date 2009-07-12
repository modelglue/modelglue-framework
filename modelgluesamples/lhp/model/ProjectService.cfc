<cfcomponent output="false" displayName="Project Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="ProjectService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="projectGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.projectGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteProjects" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteProject(id)>
		</cfloop>
		
	</cffunction>

	<cffunction name="getMailProjects" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getMailProjects()>
	</cffunction>
	
	<cffunction name="getProject" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getProject(arguments.id)>
		<cfelse>
			<cfreturn variables.gateway.newProject()>
		</cfif>
	</cffunction>
	
	<cffunction name="getProjects" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getProjects()>
	</cffunction>

	<cffunction name="getProjectsForUser" access="public" returnType="query" output="false">
		<cfargument name="user" type="any" required="true">
		<cfreturn variables.gateway.getProjectsForUser(user.getUsername())>
	</cffunction>

	<cffunction name="saveProject" access="public" returnType="void" output="false">
		<cfargument name="project" type="any" required="true">
		<cfset variables.gateway.saveProject(arguments.project)>
	</cffunction>
			
</cfcomponent>
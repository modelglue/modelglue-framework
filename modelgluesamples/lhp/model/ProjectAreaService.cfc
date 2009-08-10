<cfcomponent output="false" displayName="Project Area Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="ProjectAreaService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="projectAreaGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.projectAreaGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteProjectAreas" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteProjectArea(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getProjectArea" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getProjectArea(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "ProjectAreaBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getProjectAreas" access="public" returnType="query" output="false">
		<cfreturn variables.gateway.getProjectAreas()>
	</cffunction>

	<cffunction name="getProjectAreasForProjectList" access="public" returnType="query" output="false">
		<cfargument name="projectlist" type="any" required="true">
		<cfreturn variables.gateway.getProjectAreasForProjectList(arguments.projectlist)>
	</cffunction>
	
	<cffunction name="saveProjectArea" access="public" returnType="void" output="false">
		<cfargument name="projectarea" type="any" required="true">
		<cfset variables.gateway.saveProjectArea(arguments.projectarea)>
	</cffunction>
			
</cfcomponent>
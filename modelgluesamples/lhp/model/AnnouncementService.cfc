<cfcomponent output="false" displayName="Announcement Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="AnnouncementService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="announcementGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		
		<cfset variables.gateway = arguments.announcementGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteAnnouncements" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteAnnouncement(id)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getAnnouncement" access="public" returnType="any" output="false">
		<cfargument name="id" type="any" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.getAnnouncement(arguments.id)>
		<cfelse>
			<cfreturn createObject("component", "AnnouncementBean")>
		</cfif>
	</cffunction>
	
	<cffunction name="getAnnouncements" access="public" returnType="query" output="false">
		<cfargument name="projectfilter" type="any" required="false">
		<cfreturn variables.gateway.getAnnouncements(argumentCollection=arguments)>
	</cffunction>

	<cffunction name="saveAnnouncement" access="public" returnType="void" output="false">
		<cfargument name="announcement" type="any" required="true">
		<cfset variables.gateway.saveAnnouncement(arguments.announcement)>
	</cffunction>
		
</cfcomponent>
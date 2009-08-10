<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller" beans="applicationSettings,announcementService">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		<cfset var taskname = "">
		<cfset var taskURL = "">
		<cfset var theServer = "">
		
		<cfset super.init(framework) />
		
		<!--- 
		Create a scheduled task for our mail projects. The task has to be unique to the system. So base it off application name.
		--->
		<cfset taskname = "LHP " & application.applicationname>
		<cfif isBoolean(cgi.server_port_secure) and cgi.server_port_secure>
			<cfset taskURL = "https://">
		<cfelse>
			<cfset taskURL = "http://">
		</cfif>
		
		<cfset theServer = cgi.server_name>
		<cfif cgi.server_port neq 80>
			<cfset theServer = theServer & ":" & cgi.server_port>
		</cfif>
		
		<cfset taskURL = taskURL & theServer & listDeleteAt(cgi.script_name, listlen(cgi.script_name,"/"), "/")>
		<cfset taskURL = taskURL & "/index.cfm?event=action.mailprocess">
		
		<cfschedule action="update" task="#taskname#" operation="HTTPRequest" url="#taskurl#" startDate="1/1/99" startTime="12:00 AM" interval="600" requestTimeOut="600">
		
		<cfreturn this />
	</cffunction>

	<cffunction name="deleteAnnouncement" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		<cfset beans.announcementService.deleteAnnouncements(markedtodie)>
	</cffunction>
	
	<cffunction name="getAnnouncement" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("announcement", beans.announcementService.getAnnouncement(id))>
	</cffunction>

	<cffunction name="getMyAnnouncements" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var myprojects = arguments.event.getValue("myprojects")>
		<cfset arguments.event.setValue("myannouncements", beans.announcementService.getAnnouncements(valueList(myprojects.id)))>
	</cffunction>
		
	<cffunction name="getAnnouncements" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset arguments.event.setValue("announcements", beans.announcementService.getAnnouncements())>
	</cffunction>

	<cffunction name="saveAnnouncement" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var ann = arguments.event.getValue("announcement")>
		<cfset var title = htmlEditFormat(trim(arguments.event.getValue("atitle")))>
		<cfset var body = htmlEditFormat(trim(arguments.event.getValue("body")))>
		<cfset var projectidfk = htmlEditFormat(trim(arguments.event.getValue("projectidfk")))>
		<cfset var me = arguments.event.getValue("currentUser")>
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset ann.setTitle(title)>
		<cfset ann.setBody(body)>
		<cfset ann.setProjectIDFK(projectidfk)>
		<cfset ann.setUserIDFK(me.getID())>
		<cfset ann.setPosted(now())>
	
		<cfset errors = ann.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.announcementService.saveAnnouncement(ann)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	

	<cffunction name="onRequestStart" access="public" output="false">
		<cfargument name="event" type="any">
		
		<!--- copy settings to the Event scope so we can use it all the time. --->
		<cfset arguments.event.setValue("settings", beans.applicationSettings.getConfig())>

	</cffunction>

</cfcomponent>
	

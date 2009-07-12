<cfcomponent output="false" hint="Handles User related issues." extends="ModelGlue.gesture.controller.Controller" beans="applicationSettings,userService">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		
		<cfset super.init(framework) />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="checkAdmin" access="public" output="false">
		<cfargument name="event" type="any" required="true">
		<cfset var eventlist = arguments.event.getArgument("events")>
		<cfset var me = arguments.event.getValue("currentUser")>
		<cfset var thisEvent = arguments.event.getValue(arguments.event.getValue("eventValue"))>
		<cfset var e = "">
		
		<!--- If I'm an admin, leave right away --->
		<cfif me.hasRole("admin")>
			<cfreturn>
		</cfif>

		<!--- ok, so loop through eventlist, and if match, its an event we need to secure, since we got here, it means we aren't an admin --->
		<cfloop index="e" list="#eventlist#">
			<cfif findNoCase(e, thisEvent)>
				<cfset arguments.event.addResult("notAuthorized")>
			</cfif>
		</cfloop>
				
	</cffunction>
			
	<cffunction name="checkLogin" access="public" output="false">
		<cfargument name="event" type="any" required="true">
		<cfset var auth = arguments.event.getValue("auth")>
		<cfset var username = "">
		<cfset var password = "">
		<cfset var settings = "">
		
		<!--- handle auto login via rss --->
		<cfif len(auth)>	
			<cfset settings = beans.applicationSettings.getConfig()>
			<cfset auth = decrypt(auth, settings.secretkey)>
			<cfset username = listLast(listFirst(auth, "&"),"=")>
			<cfset password = listLast(listLast(auth, "&"),"=")>
			<cfif beans.userService.authenticate(username,password)>
				<cfset storeUser(beans.userService.getUserByUsername(username))>
				<cfset arguments.event.setValue("currentuser", getCurrentUser())>				
			</cfif>
		</cfif>
		
		<cfif not loggedIn()>
			<cfset arguments.event.addResult("needLogin")>
		</cfif>

	</cffunction>

	<cffunction name="clearUser" access="private" output="false">
		<cfset structDelete(session, "user")>
	</cffunction>

	<cffunction name="getCurrentUser" access="private" output="false">
		<cfreturn session.user>
	</cffunction>

	<cffunction name="deleteUser" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		<cfset beans.userService.deleteUsers(markedtodie)>
	</cffunction>
	
	<cffunction name="getUser" access="public" output="false">
		<cfargument name="event" type="any">	
		<cfset var id = arguments.event.getValue("id")>			
		<cfset arguments.event.setValue("user", beans.userService.getUser(id))>
	</cffunction>	
	
	<cffunction name="getUsers" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("users", beans.userService.getUsers())>
	</cffunction>	

	<cffunction name="loggedIn" access="private" output="false" hint="Private function to check to see if we are logged in.">
		<cfreturn structKeyExists(session, "user")>
	</cffunction>

	<cffunction name="onRequestStart" access="public" output="false">
		<cfargument name="event" type="any">
		
		<!--- copy settings to the Event scope so we can use it all the time. --->
		<cfif loggedIn()>
			<cfset arguments.event.setValue("currentuser", getCurrentUser())>
		</cfif>
		
	</cffunction>

	<cffunction name="processLogin" access="public" output="false">
		<cfargument name="event" type="any" required="true">
		<cfset var username = arguments.event.getValue("username")>
		<cfset var password = arguments.event.getValue("password")>
		
		<cfif beans.userService.authenticate(username,password)>
			<cfset storeUser(beans.userService.getUserByUsername(username))>
			<cfset arguments.event.addResult("loggedIn")>
		<cfelse>
			<cfset arguments.event.setValue("loginError",1)>
			<cfset arguments.event.addResult("notLoggedIn")>
		</cfif>
		
	</cffunction>

	<cffunction name="processLogout" access="public" output="false">
		<cfargument name="event" type="any" required="true">
		<cfset clearUser()>		
	</cffunction>

	<cffunction name="savePrefs" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var me = arguments.event.getValue("currentuser")>
		<cfset var cancel = arguments.event.getValue("cancel")>
		<cfset var errors = "">		

		<cfset var password = trim(arguments.event.getValue("password"))>
		<cfset var password2 = trim(arguments.event.getValue("password2"))>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var emailaddress = htmlEditFormat(trim(arguments.event.getValue("emailaddress")))>
		<cfset var selemailprojects = arguments.event.getValue("selemailprojects","")>

		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>

		<cfset me.setName(left(name,50))>
		<cfset me.setEmailAddress(emailaddress)>
		<cfset me.setEmailProjects(selemailprojects)>
				
		<cfset errors = me.validate()>
		
		<cfif len(password)>
			<cfif not password2 eq password>
				<cfset arrayAppend(errors, "Your new password and the confirmation did not match.")>
			<cfelse>
				<cfset me.setPassword(password)>
			</cfif>
		</cfif>
				
		<cfif not arrayLen(errors)>
			<cftry>
				<cfset beans.userService.saveUser(me)>
				<cfset storeUser(me)>
				<cfset arguments.event.setValue("message","Your preferences have been updated.")>
				<cfcatch>
					<cfset errors[1] = cfcatch.message>			
					<cfset arguments.event.setValue("errors", errors)>
					<cfset arguments.event.addResult("bad")>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
		</cfif>
			
	</cffunction>	
	
	<cffunction name="saveUser" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var u = arguments.event.getValue("user")>
		<cfset var cancel = arguments.event.getValue("cancel")>
		<cfset var errors = "">		
		<cfset var username = htmlEditFormat(trim(arguments.event.getValue("username")))>
		<cfset var resetpassword = arguments.event.getValue("resetpassword")>
		<cfset var password = trim(arguments.event.getValue("password"))>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var emailaddress = htmlEditFormat(trim(arguments.event.getValue("emailaddress")))>
		<cfset var selprojects = arguments.event.getValue("selprojects","")>
		<cfset var selemailprojects = arguments.event.getValue("selemailprojects","")>
		<cfset var admin = arguments.event.getValue("admin")>
		
		<cfset u.setUserName(left(username,50))>
		<cfif resetpassword>
			<cfset u.setPassword(password)>
		</cfif>
		<cfset u.setName(left(name,50))>
		<cfset u.setEmailAddress(emailaddress)>

		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>

		<cfset u.setProjects(selprojects)>
		<cfset u.setEmailProjects(selemailprojects)>
		
		<!--- roles is a bit hackish now --->
		<cfif admin>
			<cfset u.setRoles("admin")>
		<cfelse>
			<cfset u.setRoles("")>
		</cfif>
		
		<cfset errors = u.validate()>
				
		<cfif not arrayLen(errors)>
			<cftry>
				<cfset beans.userService.saveUser(u)>
				<cfset arguments.event.addResult("good")>
				<cfcatch>
					<cfset errors[1] = cfcatch.message>			
					<cfset arguments.event.setValue("errors", errors)>
					<cfset arguments.event.addResult("bad")>
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	
		
	<cffunction name="storeUser" access="private" output="false">
		<cfargument name="user" type="any" required="true">
		<cfset session.user = arguments.user>
	</cffunction>
		
</cfcomponent>
	

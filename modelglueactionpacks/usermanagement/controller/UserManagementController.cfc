<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfcomponent output="false" hint="I am a Model-Glue controller." extends="modelglueactionpacks.usermanagement.controller.AbstractUserManagementController"
						 beans="ObjectFactory, UserService, UserSessionFacade"
>

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfreturn this />
	</cffunction>

	<cffunction name="setUserManagementConfiguration" output="false">
		<cfargument name="UserManagementConfiguration" />
		
		<cfset variables.configSettings = arguments.userManagementConfiguration.getConfig() />
	</cffunction>

	<cffunction name="getUserManagementValues" output="false">
		<cfargument name="event" />
		
		<cfset arguments.event.setValue("currentUser", beans.userSessionFacade.getCurrentUser()) />
		
		<cfset arguments.event.setValue("allowUserSignup", variables.configSettings.allowUserSignup) />
	</cffunction>
	
	<cffunction name="checkUserAccessToCurrentEvent" output="false">
		<cfargument name="event" />
		
		<cfset var eventName = arguments.event.getInitialEventHandlerName() />
		<cfset var groupId = "" />
		<cfset var validEvent = false />
		<cfset var user = arguments.event.getValue("currentUser") />
		
		<cfif not structKeyExists(variables.eventMap, eventName)>
			<cfset arguments.event.addResult("securedEvent.userNotInPermittedGroup") />
		<cfelse>
			<cfset validEvent = userHasAccessToEvent(user, eventName)/>
		</cfif>
		
		<cfif not validEvent>
			<cfset arguments.event.addResult("securedEvent.userNotInPermittedGroup") />
		</cfif>
	</cffunction>

	<cffunction name="enforceLogin" output="false">
		<cfargument name="event" />
		
		<cfif variables.configSettings.requireLogin and not arguments.event.getValue("currentUser").getIsLoggedIn()>
			<cfif not structKeyExists(variables.configSettings.anonymousEvents, arguments.event.getValue(arguments.event.getValue("eventValue")))>	
				<cfset arguments.event.forward(variables.configSettings.loginEvent) />		
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="addNavigation" output="false">
		<cfargument name="event" />
		
		<cfset var navigationSections = arguments.event.getValue("navigationSections", arrayNew(1)) />
		<cfset var user = arguments.event.getValue("currentUser") />
		
		<cfif userHasAccessToEvent(user, "userManagement.user.list")>
			<cfset arrayAppend(navigationSections, variables.configSettings.userManagementNavigation) />
			
		</cfif>

		<cfif userHasAccessToEvent(user, "userManagement.securedModelGlueEvent.list")>
			<cfset arrayAppend(navigationSections, variables.configSettings.securityManagementNavigation) />
		</cfif>

		<cfset arguments.event.setValue("navigationSections", navigationSections) />
	</cffunction>

	<cffunction name="loginScreen" output="false" hint="I am a message listener function generated for the ""UserManagement.loginScreen"" event.">
		<cfargument name="event" />
		
		<!--- 
			Put "behind the scenes" query, form validation, and model interaction code here.
			  
			Use event.getValue("name") to get variables from the FORM and URL scopes.
		--->
	</cffunction>

	<cffunction name="createAccount" output="false" hint="I am a message listener function generated for the ""userManagement.createAccount"" event.">
		<cfargument name="event" />
		
		<cfset var user = beans.objectFactory.new("modelglueactionpacks.usermanagement.model.User") />
		<cfset var validation = "" />
				
		<cfif not variables.configSettings.allowUserSignup>
			<cfthrow message="Users may not create accounts." />
		</cfif>
		
		<cfset arguments.event.makeEventBean(user) />
		
		<cfset validation = user.validate() />

		<cfif not len(arguments.event.getValue("password2"))>
			<cfset validation.addError("password2", "Please re-enter your password.") />
		</cfif>
				
		<cfif user.getPassword() neq arguments.event.getValue("password2")>
			<cfset validation.addError("password", "The two passwords entered did not match.") />
		</cfif> 
		
		<cfif validation.hasErrors()>
			<cfset arguments.event.setValue("createUserValidationErrors", validation) />
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset beans.userService.saveUser(user) />
			
			<cfset user.login() />
			
			<cfset arguments.event.addResult("userCreated") />
		</cfif>
		
	</cffunction>

	<cffunction name="login" output="false" hint="I am a message listener function generated for the ""userManagement.login"" event.">
		<cfargument name="event" />
		
		<cfset var user = beans.objectFactory.new("modelglueactionpacks.usermanagement.model.User") />
		<cfset var validation = "" />
		
		<cfset user.setUsername(arguments.event.getValue("loginUsername")) />
		<cfset user.setPassword(arguments.event.getValue("loginPassword")) />
		
		<cfset validation = user.validateForAuthentication() />
		
		<cfset arguments.event.setValue("loginUserValidationErrors", validation) />

		<cfif validation.hasErrors()>
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset user.login() />
			
			<cfif user.getIsLoggedIn()>
				<cfset arguments.event.addResult("userLoggedIn") />
			<cfelse>
				<cfset validation.addError("username", "Invalid username or password.") />
				<cfset arguments.event.addResult("badCredentials") />
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="logout" output="false" hint="I am a message listener function generated for the ""userManagement.logout"" event.">
		<cfargument name="event" />
		
		<cfset var user = arguments.event.getValue("currentUser") />
		
		<cfset user.logout() />

		<cfset arguments.event.setValue("currentUser", beans.userSessionFacade.getCurrentUser()) />
	</cffunction>

	<cffunction name="listUsers" output="false" hint="I am a message listener function generated for the ""usermanagement.user.list"" event.">
		<cfargument name="event" />
		
		<cfset var users = beans.userService.listUsers() />
		
		<cfset arguments.event.setValue("users", users) /> 
	</cffunction>

	<cffunction name="deleteUsers" output="false" hint="I am a message listener function generated for the ""userManagement.user.delete"" event.">
		<cfargument name="event" />
		
		<cfset var userIds = event.getValue("userId") />
		<cfset var i = "" />

		<cfloop list="#userIds#" index="i">
			<cfset beans.userService.deleteUser(i) />
		</cfloop>
	</cffunction>

	<cffunction name="getUser" output="false" hint="I am a message listener function generated for the ""userManagement.user.edit"" event.">
		<cfargument name="event" />

		<cfif not arguments.event.exists("user")>
			<cfset arguments.event.setValue("user", beans.userService.getUser(arguments.event.getValue("userId", 0))) />		
		</cfif>
	</cffunction>	

	<cffunction name="saveUser" output="false" hint="I am a message listener function generated for the ""userManagement.user.edit"" event.">
		<cfargument name="event" />

		<cfset var user = arguments.event.getValue("user") />
		<cfset var resetPassword = true />
		<cfset var validation = "" />
		<cfset user.setUsername(arguments.event.getValue("username")) />
		<cfset user.setEmailAddress(arguments.event.getValue("emailAddress")) />

		<cfset validation = user.validate() />

		<cfif not len(arguments.event.getValue("password")) or not len(arguments.event.getValue("password2"))>
			<cfset resetPassword = false />
		</cfif>
		
		<cfif len(arguments.event.getValue("password")) and not len(arguments.event.getValue("password2"))>
			<cfset validation.addError("password2", "Please re-enter the user's password.") />
			<cfset resetPassword = false />
		</cfif>
				
		<cfif len(arguments.event.getValue("password")) and arguments.event.getValue("password") neq arguments.event.getValue("password2")>
			<cfset validation.addError("password", "The two passwords entered did not match.") />
			<cfset resetPassword = false />
		</cfif>

		<cfif len(arguments.event.getValue("password")) and len(arguments.event.getValue("password")) gt 50>
			<cfset validation.addError("password", "Please enter a password that's 50 characters or less.") />
			<cfset resetPassword = false />
		</cfif>
		
		<cfif resetPassword>
			<cfset user.setPassword(arguments.event.getValue("password")) />
			<cfset validation = user.validate() />
		</cfif>
		
		
		<cfif validation.hasErrors()>
			<cfset arguments.event.setValue("validationErrors", validation) />
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset beans.userService.saveUser(user) />
			
			<cfset arguments.event.addResult("userSaved") />
		</cfif>	
	</cffunction>	

	<cffunction name="listGroups" output="false" hint="I am a message listener function generated for the ""groupmanagement.group.list"" event.">
		<cfargument name="event" />
		
		<cfset var groups = beans.userService.listGroups() />
		
		<cfset arguments.event.setValue("groups", groups) /> 
	</cffunction>

	<cffunction name="deleteGroups" output="false" hint="I am a message listener function generated for the ""groupManagement.group.delete"" event.">
		<cfargument name="event" />
		
		<cfset var groupIds = event.getValue("groupId") />
		<cfset var i = "" />

		<cfloop list="#groupIds#" index="i">
			<cfset beans.userService.deleteGroup(i) />
		</cfloop>
	</cffunction>

	<cffunction name="getGroup" output="false" hint="I am a message listener function generated for the ""groupManagement.group.edit"" event.">
		<cfargument name="event" />

		<cfif not arguments.event.exists("group")>
			<cfset arguments.event.setValue("group", beans.userService.getGroup(arguments.event.getValue("groupId", 0))) />		
		</cfif>
		
		<cfset arguments.event.setValue("groupMembers", beans.userService.listUserGroupRelationshipStatus(arguments.event.getValue("groupId", 0))) />
		<cfset arguments.event.setValue("groupEvents", beans.userService.listGroupEventRelationshipStatus(arguments.event.getValue("groupId", 0))) />
	</cffunction>	

	<cffunction name="saveGroup" output="false" hint="I am a message listener function generated for the ""groupManagement.group.edit"" event.">
		<cfargument name="event" />

		<cfset var group = arguments.event.getValue("group") />
		<cfset var validation = "" />
		<cfset arguments.event.makeEventBean(group) />				

		<cfset validation = group.validate() />
		
		<cfif validation.hasErrors()>
			<cfset arguments.event.setValue("validationErrors", validation) />
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset beans.userService.saveGroup(group) />
			<cfset beans.userService.updateUserGroupRelationships(group.getGroupId(), listToArray(arguments.event.getValue("userId"))) />
			<cfset beans.userService.updateGroupEventRelationships(group.getGroupId(), listToArray(arguments.event.getValue("eventId"))) />
			<cfset arguments.event.addResult("groupSaved") />
		</cfif>	
	</cffunction>	

	<cffunction name="listSecuredModelGlueEvents" output="false" hint="I am a message listener function generated for the ""securedModelGlueEventmanagement.securedModelGlueEvent.list"" event.">
		<cfargument name="event" />
		
		<cfset var securedModelGlueEvents = beans.userService.listSecuredModelGlueEvents() />
		
		<cfset arguments.event.setValue("securedModelGlueEvents", securedModelGlueEvents) /> 
	</cffunction>

	<cffunction name="deleteSecuredModelGlueEvents" output="false" hint="I am a message listener function generated for the ""securedModelGlueEventManagement.securedModelGlueEvent.delete"" event.">
		<cfargument name="event" />
		
		<cfset var eventIds = event.getValue("eventId") />
		<cfset var i = "" />

		<cfloop list="#eventIds#" index="i">
			<cfset beans.userService.deleteSecuredModelGlueEvent(i) />
		</cfloop>
	</cffunction>

	<cffunction name="getSecuredModelGlueEvent" output="false" hint="I am a message listener function generated for the ""securedModelGlueEventManagement.securedModelGlueEvent.edit"" event.">
		<cfargument name="event" />

		<cfif not arguments.event.exists("securedModelGlueEvent")>
			<cfset arguments.event.setValue("securedModelGlueEvent", beans.userService.getSecuredModelGlueEvent(arguments.event.getValue("eventId", 0))) />		
		</cfif>
	</cffunction>	

	<cffunction name="saveSecuredModelGlueEvent" output="false" hint="I am a message listener function generated for the ""securedModelGlueEventManagement.securedModelGlueEvent.edit"" event.">
		<cfargument name="event" />

		<cfset var securedModelGlueEvent = arguments.event.getValue("securedModelGlueEvent") />
		<cfset var validation = "" />
		<cfset arguments.event.makeEventBean(securedModelGlueEvent) />				

		<cfset validation = securedModelGlueEvent.validate() />
		
		<cfif validation.hasErrors()>
			<cfset arguments.event.setValue("validationErrors", validation) />
			<cfset arguments.event.addResult("validationErrors") />
		<cfelse>
			<cfset beans.userService.saveSecuredModelGlueEvent(securedModelGlueEvent) />
			
			<cfset arguments.event.addResult("securedModelGlueEventSaved") />
		</cfif>	
	</cffunction>	
</cfcomponent>
	

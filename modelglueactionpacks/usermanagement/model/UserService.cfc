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



<cfcomponent name="UserService" output="false">

	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.UserService">
		<cfargument name="objectFactory" type="any" required="true" />
		<cfargument name="UserDAO" type="modelglueactionpacks.usermanagement.model.UserDAO" required="true" />
		<cfargument name="UserGateway" type="modelglueactionpacks.usermanagement.model.UserGateway" required="true" />
		<cfargument name="GroupDAO" type="modelglueactionpacks.usermanagement.model.GroupDAO" required="true" />
		<cfargument name="GroupGateway" type="modelglueactionpacks.usermanagement.model.GroupGateway" required="true" />
		<cfargument name="SecuredModelGlueEventDAO" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventDAO" required="true" />
		<cfargument name="SecuredModelGlueEventGateway" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventGateway" required="true" />

		<cfset variables.objectFactory = arguments.objectFactory />
		<cfset variables.UserDAO = arguments.UserDAO />
		<cfset variables.UserGateway = arguments.UserGateway />
		<cfset variables.GroupDAO = arguments.GroupDAO />
		<cfset variables.GroupGateway = arguments.GroupGateway />
		<cfset variables.SecuredModelGlueEventDAO = arguments.SecuredModelGlueEventDAO />
		<cfset variables.SecuredModelGlueEventGateway = arguments.SecuredModelGlueEventGateway />
		
		<cfreturn this/>
	</cffunction>

	<cffunction name="createUser" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.User">
		<cfargument name="userId" type="numeric" required="true" />
		<cfargument name="username" type="string" required="false" />
		<cfargument name="password" type="string" required="false" />
		<cfargument name="emailAddress" type="string" required="false" />
		
			
		<cfset var User = variables.objectFactory.new("modelglueactionpacks.usermanagement.model.User", arguments) />
		<cfreturn User />
	</cffunction>

	<cffunction name="getUser" access="public" output="false" returntype="User">
		<cfargument name="userId" type="numeric" required="true" />
		
		<cfreturn variables.UserDAO.read(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveUser" access="public" output="false" >
		<cfargument name="User" type="modelglueactionpacks.usermanagement.model.User" required="true" />

		<cfset variables.UserDAO.save(User) />
	</cffunction>

	<cffunction name="deleteUser" access="public" output="false" >
		<cfargument name="userId" type="numeric" required="true" />
		
		<cfset var User = createUser(argumentCollection=arguments) />
		<cfset variables.UserDAO.delete(User) />
	</cffunction>

	<cffunction name="listUsers" access="public" output="false" returntype="query">
		<cfargument name="userId" type="numeric" required="false" />
		<cfargument name="username" type="string" required="false" />
		<cfargument name="password" type="string" required="false" />
		<cfargument name="emailAddress" type="string" required="false" />
		
		<cfreturn variables.UserGateway.listByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="createGroup" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.Group">
		<cfargument name="GroupId" type="numeric" required="true" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		
			
		<cfset var Group = variables.objectFactory.new("modelglueactionpacks.usermanagement.model.Group", arguments) />
		<cfreturn Group />
	</cffunction>

	<cffunction name="getGroup" access="public" output="false" returntype="Group">
		<cfargument name="GroupId" type="numeric" required="true" />
		
		<cfreturn variables.GroupDAO.read(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveGroup" access="public" output="false" >
		<cfargument name="Group" type="modelglueactionpacks.usermanagement.model.Group" required="true" />

		<cfset variables.GroupDAO.save(Group) />
	</cffunction>

	<cffunction name="deleteGroup" access="public" output="false" >
		<cfargument name="GroupId" type="numeric" required="true" />
		
		<cfset var Group = createGroup(argumentCollection=arguments) />
		<cfset variables.GroupDAO.delete(Group) />
	</cffunction>

	<cffunction name="listGroups" access="public" output="false" returntype="query">
		<cfargument name="GroupId" type="numeric" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		
		<cfreturn variables.GroupGateway.listByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="createSecuredModelGlueEvent" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent">
		<cfargument name="EventId" type="numeric" required="true" />
		<cfargument name="Name" type="string" required="false" />
		
			
		<cfset var SecuredModelGlueEvent = variables.objectFactory.new("modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent", arguments) />
		<cfreturn SecuredModelGlueEvent />
	</cffunction>

	<cffunction name="getSecuredModelGlueEvent" access="public" output="false" returntype="SecuredModelGlueEvent">
		<cfargument name="EventId" type="numeric" required="true" />
		
		<cfreturn variables.SecuredModelGlueEventDAO.read(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveSecuredModelGlueEvent" access="public" output="false" >
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfset variables.SecuredModelGlueEventDAO.save(SecuredModelGlueEvent) />
	</cffunction>

	<cffunction name="deleteSecuredModelGlueEvent" access="public" output="false" >
		<cfargument name="EventId" type="numeric" required="true" />
		
		<cfset var SecuredModelGlueEvent = createSecuredModelGlueEvent(argumentCollection=arguments) />
		<cfset variables.SecuredModelGlueEventDAO.delete(SecuredModelGlueEvent) />
	</cffunction>

	<cffunction name="listSecuredModelGlueEvents" access="public" output="false" returntype="query">
		<cfargument name="EventId" type="numeric" required="false" />
		<cfargument name="Name" type="string" required="false" />
		
		<cfreturn variables.SecuredModelGlueEventGateway.listByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="listEventsWithAllowedGroups" access="public" output="false" returntype="query">
		
		<cfreturn variables.SecuredModelGlueEventGateway.listEventsWithAllowedGroups(argumentCollection=arguments) />
	</cffunction>


	<cffunction name="listUserGroupRelationshipStatus" access="public" output="false">
		<cfargument name="groupId" />
		
		<cfreturn variables.groupGateway.listUserGroupRelationshipStatus(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="updateUserGroupRelationships" access="public" output="false" returntype="void">
		<cfargument name="GroupId" type="numeric" required="true" />
		<cfargument name="userIds" type="array" required="true" hint="List of UserId's to join to the group.">
		
		<cfreturn variables.groupGateway.updateUserGroupRelationships(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="listGroupEventRelationshipStatus" access="public" output="false">
		<cfargument name="groupId" />
		
		<cfreturn variables.groupGateway.listGroupEventRelationshipStatus(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="updateGroupEventRelationships" access="public" output="false" returntype="void">
		<cfargument name="GroupId" type="numeric" required="true" />
		<cfargument name="eventIds" type="array" required="true" hint="List of EventId's to join to the group.">
		
		<cfreturn variables.groupGateway.updateGroupEventRelationships(argumentCollection=arguments) />
	</cffunction>


</cfcomponent>

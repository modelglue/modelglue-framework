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



<cfcomponent displayname="User" output="false">
		<cfproperty name="userId" type="numeric" default="" />
		<cfproperty name="isLoggedIn" type="boolean" default="false" />
		<cfproperty name="username" type="string" default="" />
		<cfproperty name="password" type="string" default="" />
		<cfproperty name="emailAddress" type="string" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="modelglueactionpacks.usermanagement.model.User" output="false">
		<cfargument name="userId" type="string" required="false" default="0" />
		<cfargument name="username" type="string" required="false" default="" />
		<cfargument name="password" type="string" required="false" default="" />
		<cfargument name="emailAddress" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setuserId(arguments.userId) />
		<cfset setusername(arguments.username) />
		<cfset setpassword(arguments.password) />
		<cfset setemailAddress(arguments.emailAddress) />
		<cfset variables.instance.isLoggedIn = false />
		<cfset variables.instance.groupIdMap = structNew() />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="modelglueactionpacks.usermanagement.model.User" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="any" output="false">
		<cfset var errors = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
		<cfset var thisError = structNew() />
		<cfset var duplicates = "" />
		
		<!--- userId --->
		<cfif (len(trim(getuserId())) AND NOT isNumeric(trim(getuserId())))>
			<cfset errors.addError("userId", "userId must be a number.") />
		</cfif>
		
		<!--- username --->
		<cfif (NOT len(trim(getusername())))>
			<cfset errors.addError("username", "Username is required.") />
		</cfif>
		<cfif (len(trim(getusername())) AND NOT IsSimpleValue(trim(getusername())))>
			<cfset errors.addError("username", "Username must be a simple value.") />
		</cfif>
		<cfif (len(trim(getusername())) GT 50)>
			<cfset errors.addError("username", "Username must be 50 characters or less.") />
		</cfif>
		<cfif getUserId() eq 0 and len(trim(getUsername()))>
			<cfset duplicates = getService("UserGateway").listByAttributes(username=getUsername(),anonymousAccount=false) />
			<cfif duplicates.recordCount>
				<cfset errors.addError("username", "This username is already in use.  Please choose another.") />
			</cfif>
		</cfif>
		
		<!--- password --->
		<cfif (NOT len(trim(getpassword())))>
			<cfset errors.addError("password", "Password is required.") />
		</cfif>
		<cfif (len(trim(getpassword())) AND NOT IsSimpleValue(trim(getpassword())))>
			<cfset errors.addError("password", "Password must be a simple value.") />
		</cfif>
		<cfif (len(trim(getpassword())) GT 50)>
			<cfset errors.addError("password", "Password must be 50 characters or less.") />
		</cfif>
		
		<!--- emailAddress --->
		<cfif (NOT len(trim(getemailAddress())))>
			<cfset errors.addError("emailAddress", "E-Mail Address is required.") />
		</cfif>
		<cfif (len(trim(getemailAddress())) AND NOT IsSimpleValue(trim(getemailAddress())))>
			<cfset errors.addError("emailAddress", "E-Mail Address must be a simple value.") />
		</cfif>
		<cfif (len(trim(getemailAddress())) GT 200)>
			<cfset errors.addError("emailAddress", "E-Mail Address must be 200 characters or less.") />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<cffunction name="validateForAuthentication" access="public" returntype="any" output="false">
		<cfset var errors = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />
		
		<!--- username --->
		<cfif (NOT len(trim(getusername())))>
			<cfset errors.addError("username", "username is required.") />
		</cfif>
		<cfif (len(trim(getusername())) AND NOT IsSimpleValue(trim(getusername())))>
			<cfset errors.addError("username", "username must be a simple value.") />
		</cfif>
		<cfif (len(trim(getusername())) GT 50)>
			<cfset errors.addError("username", "username must be 50 characters or less.") />
		</cfif>
		
		<!--- password --->
		<cfif (NOT len(trim(getpassword())))>
			<cfset errors.addError("password", "password is required.") />
		</cfif>
		<cfif (len(trim(getpassword())) AND NOT IsSimpleValue(trim(getpassword())))>
			<cfset errors.addError("password", "password must be a simple value.") />
		</cfif>
		<cfif (len(trim(getpassword())) GT 50)>
			<cfset errors.addError("password", "password must be 50 characters or less.") />
		</cfif>
		
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setuserId" access="public" returntype="void" output="false">
		<cfargument name="userId" type="string" required="true" />
		<cfset variables.instance.userId = arguments.userId />
	</cffunction>
	<cffunction name="getuserId" access="public" returntype="string" output="false">
		<cfreturn variables.instance.userId />
	</cffunction>

	<cffunction name="setusername" access="public" returntype="void" output="false">
		<cfargument name="username" type="string" required="true" />
		<cfset variables.instance.username = arguments.username />
	</cffunction>
	<cffunction name="getusername" access="public" returntype="string" output="false">
		<cfreturn variables.instance.username />
	</cffunction>

	<cffunction name="setpassword" access="public" returntype="void" output="false">
		<cfargument name="password" type="string" required="true" />
		<cfset variables.instance.password = arguments.password />
	</cffunction>
	<cffunction name="getpassword" access="public" returntype="string" output="false">
		<cfreturn variables.instance.password />
	</cffunction>

	<cffunction name="setemailAddress" access="public" returntype="void" output="false">
		<cfargument name="emailAddress" type="string" required="true" />
		<cfset variables.instance.emailAddress = arguments.emailAddress />
	</cffunction>
	<cffunction name="getemailAddress" access="public" returntype="string" output="false">
		<cfreturn variables.instance.emailAddress />
	</cffunction>

	<cffunction name="getisLoggedIn" access="public" returntype="boolean" output="false">
		<cfreturn variables.instance.isLoggedIn />
	</cffunction>

	<!--- Methods --->
	<cffunction name="isInGroup" returnType="boolean">
		<cfargument name="groupId" />
		
		<cfreturn structKeyExists(variables.instance.groupIdMap, arguments.groupId) />
	</cffunction>
	
	<cffunction name="refreshGroupMap">
		<cfset var groups = "" />

		<cfset groups = getService("GroupGateway").listGroupsForUser(getUserId()) />
		
		<cfset variables.instance.groupIdMap = structNew() />
		<cfloop query="groups">
			<cfset variables.instance.groupIdMap[groups.groupId] = true />
		</cfloop>
	</cffunction>
	
	<cffunction name="login" access="public">
		<cfset var facade = getService("UserSessionFacade") />
		<cfset var gateway = "" />
		<cfset var results = getService("UserGateway").listByAttributes(username=getUsername(),password=getPassword()) />

		<cfif results.recordCount>
			<cfset getService("UserDAO").read(userId=results.userId, bean=this) />
			<cfset variables.instance.isLoggedIn = true />
			<cfset facade.storeUser(this) />
		<cfelse>
			<cfset logout() />
		</cfif>
	</cffunction>
	
	<cffunction name="logout" access="public">
		<cfset var facade = getService("UserSessionFacade") />

		<cfset init() />
		
		<cfset facade.purgeUser(this) />
	</cffunction>
	
	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>

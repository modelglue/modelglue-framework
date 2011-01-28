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


<cfcomponent>
	
	<cfset variables.instance = structNew() />
	<cffunction name="init" returntype="CurrentPage" output="false">
		<cfargument name="eventName" type="string" default=""/>
		
		<cfset variables.instance.eventName = arguments.eventName />
		<cfreturn this />
	</cffunction>

	<cffunction name="isSelectedMenu" returntype="boolean" output="false">
		<cfargument name="menu" type="string" default="">
		<cfset var rtnVal = false />
		 
		<cfif arguments.menu IS "Home">
			<cfif len(trim(variables.instance.eventName)) IS 0 OR variables.instance.eventName IS "home">
				<cfset rtnVal = true />
			</cfif>
		<cfelseif arguments.menu IS "logout">
			<cfif listFirst( variables.instance.eventName, ".") IS "Logout">
				<cfset rtnVal = true />
			</cfif>			
		</cfif> 

		<cfreturn rtnVal />
	</cffunction>

</cfcomponent>

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



<cfcomponent displayname="SecuredModelGlueEventGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventGateway">
		<cfargument name="datasource" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listByAttributes" access="public" output="false" returntype="query">
		<cfargument name="EventId" type="numeric" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			SELECT
				EventId,
				Name
			FROM	securedModelGlueEvent
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"EventId") and len(arguments.EventId)>
			AND	EventId = <cfqueryparam value="#arguments.EventId#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments,"Name") and len(arguments.Name)>
			AND	Name = <cfqueryparam value="#arguments.Name#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		<cfelse>
			order by name
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="listEventsWithAllowedGroups" access="public" output="false" returntype="query">
		<cfset var qList = "" />
		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			select
				e.eventId,
				g.groupId,
				g.name as groupName,
				e.name as eventName
			from
				securedModelGlueEvent e
				left join groupSecuredModelGlueEventRelationship gr on e.eventId = gr.eventId
				left join `group` g on gr.groupId = g.groupId
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	
</cfcomponent>

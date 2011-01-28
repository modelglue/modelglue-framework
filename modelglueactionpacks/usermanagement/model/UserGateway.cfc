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



<cfcomponent displayname="UserGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.UserGateway">
		<cfargument name="datasource" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listByAttributes" access="public" output="false" returntype="query">
		<cfargument name="userId" type="numeric" required="false" />
		<cfargument name="username" type="string" required="false" />
		<cfargument name="password" type="string" required="false" />
		<cfargument name="emailAddress" type="string" required="false" />
		<cfargument name="anonymousAccount" type="string" required="false" default="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			SELECT
				userId,
				username,
				password,
				emailAddress
			FROM	user
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"userId") and len(arguments.userId)>
			AND	userId = <cfqueryparam value="#arguments.userId#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments,"username") and len(arguments.username)>
			AND	username = <cfqueryparam value="#arguments.username#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"password") and len(arguments.password)>
			AND	password = <cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"emailAddress") and len(arguments.emailAddress)>
			AND	emailAddress = <cfqueryparam value="#arguments.emailAddress#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"anonymousAccount") and len(arguments.anonymousAccount)>
			AND	anonymousAccount = <cfqueryparam value="#arguments.anonymousAccount#" CFSQLType="cf_sql_bit" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

</cfcomponent>

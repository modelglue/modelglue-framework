
<cfcomponent displayname="GroupGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.GroupGateway">
		<cfargument name="datasource" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="listByAttributes" access="public" output="false" returntype="query">
		<cfargument name="GroupId" type="numeric" required="false" />
		<cfargument name="Name" type="string" required="false" />
		<cfargument name="Description" type="string" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			SELECT
				GroupId,
				Name,
				Description
			FROM	`group`
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"GroupId") and len(arguments.GroupId)>
			AND	GroupId = <cfqueryparam value="#arguments.GroupId#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments,"Name") and len(arguments.Name)>
			AND	Name = <cfqueryparam value="#arguments.Name#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments,"Description") and len(arguments.Description)>
			AND	Description = <cfqueryparam value="#arguments.Description#" CFSQLType="cf_sql_varchar" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		<cfelse>
			order by name
		</cfif>
		
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="listUserGroupRelationshipStatus" access="public" output="false" returntype="query">
		<cfargument name="GroupId" type="numeric" required="true" />
		
		<cfset var qList = "" />		

		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			SELECT
				u.userId,
				u.username,
				sum(case when (ugr.groupId = <cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />) then 1 else 0 end) as isMember
			FROM
				user u
				left join userGroupRelationship ugr on u.userId = ugr.userId
				left join `group` g on ugr.groupId = g.groupId
			GROUP BY u.userId
			ORDER BY u.username
		</cfquery>	
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="updateUserGroupRelationships" access="public" output="false" returntype="void">
		<cfargument name="GroupId" type="numeric" required="true" />
		<cfargument name="userIds" type="array" required="true" hint="List of UserId's to join to the group.">
		
		<cfset var i = "" />
		<cfset var qList = "" />
		
		<cftransaction>
			<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
				DELETE FROM
					userGroupRelationship
				WHERE
				 	groupId = <cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />
			</cfquery>

			<cfif arrayLen(arguments.userIds)>
				<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
					insert into userGroupRelationship
						(userId, groupId)
					values
					<cfloop from="1" to="#arrayLen(arguments.userIds)#" index="i">
						<cfif i gt 1>,</cfif>
						(<cfqueryparam value="#arguments.userIds[i]#" CFSQLType="cf_sql_integer" />,<cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />)
					</cfloop>
				</cfquery>
			</cfif>
					
		</cftransaction>
	</cffunction>

	<cffunction name="listGroupEventRelationshipStatus" access="public" output="false" returntype="query">
		<cfargument name="GroupId" type="numeric" required="true" />
		
		<cfset var qList = "" />		

		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			SELECT
				u.eventId,
				u.name,
				sum(case when (ugr.groupId = <cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />) then 1 else 0 end) as isMember
			FROM
				securedModelGlueEvent u
				left join groupSecuredModelGlueEventRelationship ugr on u.eventId = ugr.eventId
				left join `group` g on ugr.groupId = g.groupId
			GROUP BY u.eventId
			ORDER BY u.name
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

	<cffunction name="updateGroupEventRelationships" access="public" output="false" returntype="void">
		<cfargument name="GroupId" type="numeric" required="true" />
		<cfargument name="eventIds" type="array" required="true" hint="List of eventId's to join to the group.">
		
		<cfset var i = "" />
		<cfset var qList = "" />

		<cftransaction>
			<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
				DELETE FROM
					groupSecuredModelGlueEventRelationship
				WHERE
				 	groupId = <cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />
			</cfquery>

			<cfif arrayLen(arguments.eventIds)>
				<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
					insert into groupSecuredModelGlueEventRelationship
						(eventId, groupId)
					values
					<cfloop from="1" to="#arrayLen(arguments.eventIds)#" index="i">
						<cfif i gt 1>,</cfif>
						(<cfqueryparam value="#arguments.eventIds[i]#" CFSQLType="cf_sql_integer" />,<cfqueryparam value="#arguments.groupId#" CFSQLType="cf_sql_integer" />)
					</cfloop>
				</cfquery>
			</cfif>
					
		</cftransaction>
	</cffunction>


	<cffunction name="listGroupsForUser" access="public" output="false" returntype="query">
		<cfargument name="userId" />

		<cfset var qList = "" />
		<cfquery name="qList" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			select
				ugr.groupId
			from
				user u
				join userGroupRelationship ugr on u.userId = ugr.userId
			where
				u.userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#" />
		</cfquery>
		
		<cfreturn qList />
	</cffunction>
</cfcomponent>

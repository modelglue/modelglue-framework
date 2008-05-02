
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

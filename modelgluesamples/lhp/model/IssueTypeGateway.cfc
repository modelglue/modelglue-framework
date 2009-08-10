<cfcomponent output="false" displayName="Issue Type Gateway">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="IssueTypeGateway" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteIssueType" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_issuetypes
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
					
	</cffunction>
	
	<cffunction name="getIssueType" access="public" returnType="IssueTypeBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var bean = createObject("component","IssueTypeBean")>
		<cfset var getit = "">
		<cfset var col = "">
		
		<cfquery name="getit" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 	id, name
			from	lh_issuetypes
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfloop index="col" list="#getit.columnlist#">
				<cfinvoke component="#bean#" method="set#col#">
					<cfinvokeargument name="#col#" value="#getit[col][1]#">
				</cfinvoke>	
			</cfloop>
		</cfif>
		
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="getIssueTypes" access="public" returnType="query" output="false" hint="Gets all the issue types.">		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select
				id, name
			from 
				lh_issuetypes
			order by
				name asc
		</cfquery>
		
		<cfreturn data>
	</cffunction>

	<cffunction name="saveIssueType" access="public" returnType="void" output="false">
		<cfargument name="bean" type="any" required="true">
		<cfset var newID = "">

		<cfif len(bean.getId()) and bean.getId() neq 0>

			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update lh_issuetypes
			set
				name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">
	
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getID()#" maxlength="35">
			</cfquery>
								
		<cfelse>

			<cfset newID = createUUID()>

			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
				insert into lh_issuetypes(id,name)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">
					)
			</cfquery>
		
		</cfif>

	</cffunction>
	
</cfcomponent>
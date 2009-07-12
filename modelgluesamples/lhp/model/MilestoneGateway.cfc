<cfcomponent output="false" displayName="Milestone Gateway">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="MilestoneGateway" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteMilestone" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_milestones
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
	</cffunction>
	
	<cffunction name="getMilestone" access="public" returnType="MilestoneBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var bean = createObject("component","MilestoneBean")>
		<cfset var getit = "">
		<cfset var col = "">
		
		<cfquery name="getit" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 	id, name, duedate, projectidfk
			from	lh_milestones
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
	
	<cffunction name="getMilestones" access="public" returnType="query" output="false" hint="Gets all the issue types.">		
		<cfargument name="p" type="any" required="true" hint="Project ID">
		<cfset var data = "">
		<cfset var theid = "">
		
		<!--- support either ID or project bean --->
		<cfif isSimpleValue(arguments.p)>
			<cfset theid = arguments.p>
		<cfelse>
			<cfset theid = arguments.p.getId()>
		</cfif>		
		
		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select
				id, name, duedate
			from 
				lh_milestones
			where
				projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#theid#" maxlength="35">
			order by
				name asc
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="saveMilestone" access="public" returnType="void" output="false">
		<cfargument name="bean" type="any" required="true">
		<cfset var newID = "">
		<cfset var insRec = "" />
		<cfif len(bean.getId()) and bean.getId() neq 0>

			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update lh_milestones
			set
				name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">,
				duedate = 
				<cfif arguments.bean.getDueDate() neq "">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getDueDate()#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					</cfif>
				projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getID()#" maxlength="35">
			</cfquery>
				
		<cfelse>

			<cfset newID = createUUID()>

			<cfquery name="insRec" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
				insert into lh_milestones(id,name,duedate,projectidfk)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">,
					<cfif arguments.bean.getDueDate() neq "">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getDueDate()#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" null="true">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">
					)
			</cfquery>
		
		
		</cfif>

	</cffunction>
	
</cfcomponent>
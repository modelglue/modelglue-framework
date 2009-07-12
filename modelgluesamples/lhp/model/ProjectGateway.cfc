<cfcomponent output="false" displayName="Project Gateway">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="ProjectGateway" output="false">
		<cfargument name="settings" type="any" required="true">
		<!--- copied to var scope so we can copy the config to beans --->
		<cfset variables.config = arguments.settings.getConfig()>
		<cfset variables.dsn = variables.config.dsn>
		<cfset variables.username = variables.config.username /> 
		<cfset variables.password = variables.config.password />
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteProject" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
		<!--- clean up users --->
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects_users
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<!--- clean up loci links --->
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects_projectloci
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<!--- remove subscribed people --->		
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects_users_email
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

		<!--- remove issues --->	
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_issues
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="getMailProjects" access="public" returnType="query" output="false"
				hint="Returns projects that have mail settings.">
		<cfset var data = "">

		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 		p.id, p.name, p.mailserver, p.mailusername, p.mailpassword, p.mailemailaddress
			from		lh_projects p
			where 		p.mailserver <> ''
		</cfquery>

		<cfreturn data>
				
	</cffunction>
	
	<cffunction name="getProject" access="public" returnType="ProjectBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var bean = createObject("component","ProjectBean")>
		<cfset var getit = "">
		<cfset var c = "">
		
		<cfquery name="getit" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 	id, name, mailserver, mailusername, mailpassword, mailemailaddress
			from	lh_projects
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfloop index="c" list="#getit.columnlist#">
				<cfinvoke component="#bean#" method="set#c#">
					<cfinvokeargument name="#c#" value="#getIt[c][1]#">
				</cfinvoke>
			</cfloop>
		</cfif>
		
		<cfset bean.setConfig(variables.config)>
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="getProjects" access="public" returnType="query" output="false"
				hint="Gets all the projects.">		
		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 		p.id, p.name, count(i.id) as numissues, p.mailserver, p.mailusername, p.mailpassword, p.mailemailaddress
			from		lh_projects p
							left join lh_issues i on p.id = i.projectidfk
			group by	p.id, p.name, p.mailserver, p.mailusername, p.mailpassword, p.mailemailaddress
			order by 	p.name asc
		</cfquery>

		<cfreturn data>
	</cffunction>
	
	<cffunction name="getProjectsForUser" access="public" returnType="query" output="false"
				hint="Gets all the projects for the current user.">		
		<cfargument name="username" type="string" required="true">
		<cfset var data = "">

		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 		p.id, p.name
			from		lh_projects p
						, lh_projects_users pu
						, lh_users u
			where p.id = pu.projectidfk
			and   pu.useridfk = u.id
			and	  u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="35">
			order by p.name asc
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="newProject" access="public" returnType="ProjectBean" output="false">
		<cfset var bean = createObject("component","ProjectBean")>		
		<cfset bean.setConfig(variables.config)>
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="saveProject" access="public" returnType="void" output="false">
		<cfargument name="bean" type="any" required="true">
		<cfset var newID = "">
		<cfset var insRec = "" />
		<cfset var id = "">
		<cfset var i = "">
		
		<cfif len(bean.getId()) and bean.getId() neq 0>

			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update lh_projects
			set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">,
				mailserver = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailServer()#" maxlength="255">,
				mailusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailUsername()#" maxlength="255">,
				mailpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailPassword()#" maxlength="255">,
				mailemailaddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailEmailAddress()#" maxlength="255">
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getID()#" maxlength="35">
			
			</cfquery>
				
		<cfelse>

			<cfset newID = createUUID()>

			<cfquery name="insRec" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
				insert into lh_projects(id,name,mailserver,mailusername,mailpassword,mailemailaddress)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailServer()#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailUsername()#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailPassword()#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMailEmailAddress()#" maxlength="255">
					)
			</cfquery>
			<cfset arguments.bean.setId(newID)>					
		</cfif>

		<!--- handle users, project areas --->
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects_projectloci
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getId()#" maxlength="35">
		</cfquery>		

		<cfloop index="i" list="#arguments.bean.getProjectAreas()#">
			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			insert into lh_projects_projectloci(projectidfk, projectlociidfk)
			values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getId()#" maxlength="35">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" maxlength="35">)
			</cfquery>
		</cfloop>

		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_projects_users
		where projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getId()#" maxlength="35">
		</cfquery>

		<cfloop index="i" list="#arguments.bean.getUsers()#">
			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			insert into lh_projects_users(projectidfk, useridfk)
			values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getId()#" maxlength="35">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" maxlength="35">)
			</cfquery>
		</cfloop>
								
	</cffunction>
	
</cfcomponent>
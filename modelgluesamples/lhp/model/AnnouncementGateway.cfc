<cfcomponent output="false" displayName="Announcement Gateway">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	
	<cffunction name="init" access="public" returnType="AnnouncementGateway" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteAnnouncement" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
		delete from lh_announcements
		where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
			
	</cffunction>
	
	<cffunction name="getAnnouncement" access="public" returnType="AnnouncementBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var bean = createObject("component","AnnouncementBean")>
		<cfset var getit = "">
		<cfset var col = "">
		
		<cfquery name="getit" datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
			select 	id, title, body, projectidfk, useridfk, posted
			from	lh_announcements
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
	
	<cffunction name="getAnnouncements" access="public" returnType="query" output="false"
				hint="Gets all the announcements.">		
		<cfargument name="projectfilter" type="string" required="false">
		<cfset var data = "">

		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		  select  a.id, a.title, a.body, a.projectidfk, a.useridfk, a.posted,
		    p.name as project, u.name as author
		  from (lh_announcements a
		  left join lh_projects p on a.projectidfk = p.id)
		  left join lh_users u on a.useridfk = u.id
		  where 1=1
		  <cfif structKeyExists(arguments, "projectfilter") and len(arguments.projectfilter)>
		  and  (a.projectidfk in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectfilter#" list="true">)
		    or
		    a.projectidfk = ''
		    )
		  </cfif>
		  order by p.name asc, a.posted desc
		</cfquery> 
		
		<cfreturn data>
	</cffunction>

	<cffunction name="saveAnnouncement" access="public" returnType="void" output="false">
		<cfargument name="bean" type="any" required="true">
		<cfset var newID = "">

		<cfif len(bean.getId()) and bean.getId() neq 0>
		
			<cfquery  datasource="#variables.dsn#"  username="#variables.username#" password="#variables.password#">
			update lh_announcements
			set 
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getTitle()#" maxlength="50">,
				body = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getBody()#">,
				projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">,
				useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getUserIDFK()#" maxlength="35">,
				posted = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getPosted()#">	
			where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getID()#" maxlength="35">
			</cfquery>
		
		<cfelse>

			<cfset newID = createUUID()>
		
			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			insert into lh_announcements(id,title,body,projectidfk,useridfk,posted)
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getTitle()#" maxlength="50">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getBody()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getUserIDFK()#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getPosted()#">
				)
			</cfquery>
						
		</cfif>

	</cffunction>
	
</cfcomponent>
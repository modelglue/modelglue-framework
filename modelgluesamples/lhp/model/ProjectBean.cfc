<cfcomponent output="false" displayName="User Bean" hint="Manages a project.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.mailserver = "" />
	<cfset variables.instance.mailusername = "" />
	<cfset variables.instance.mailpassword = "" />
	<cfset variables.instance.mailemailaddress = "" />

	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>

	<cffunction name="setMailServer" returnType="void" access="public" output="false">
		<cfargument name="MailServer" type="string" required="true">
		<cfset variables.instance.MailServer = arguments.MailServer>
	</cffunction>
  
	<cffunction name="getMailServer" returnType="string" access="public" output="false">
		<cfreturn variables.instance.MailServer>
	</cffunction>

	<cffunction name="setMailUsername" returnType="void" access="public" output="false">
		<cfargument name="MailUsername" type="string" required="true">
		<cfset variables.instance.MailUsername = arguments.MailUsername>
	</cffunction>
  
	<cffunction name="getMailUsername" returnType="string" access="public" output="false">
		<cfreturn variables.instance.MailUsername>
	</cffunction>

	<cffunction name="setMailPassword" returnType="void" access="public" output="false">
		<cfargument name="MailPassword" type="string" required="true">
		<cfset variables.instance.MailPassword = arguments.MailPassword>
	</cffunction>
  
	<cffunction name="getMailPassword" returnType="string" access="public" output="false">
		<cfreturn variables.instance.MailPassword>
	</cffunction>

	<cffunction name="setMailEmailAddress" returnType="void" access="public" output="false">
		<cfargument name="MailEmailAddress" type="string" required="true">
		<cfset variables.instance.MailEmailAddress = arguments.MailEmailAddress>
	</cffunction>
  
	<cffunction name="getMailEmailAddress" returnType="string" access="public" output="false">
		<cfreturn variables.instance.MailEmailAddress>
	</cffunction>
	
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		<cfset var mailsum = "">
		<cfset var mailproduct = "">
		
		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfif not len(variables.instance.projectareas)>
			<cfset arrayAppend(errors,"You must select at least one project area.")>
		</cfif>

		<cfset mailsum = len(trim(getMailServer())) + len(trim(getMailUsername())) + len(trim(getMailPassword())) + len(trim(getMailEmailAddress()))>
		<cfif mailsum gt 0>
			<cfset mailproduct = len(trim(getMailServer())) * len(trim(getMailUsername())) * len(trim(getMailPassword())) * len(trim(getMailEmailAddress()))>
			<cfif mailproduct is 0>
				<cfset arrayAppend(errors, "To enable mail server support, please supply all fields.")>
			</cfif>
		</cfif>
		
		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

	<!---
	Project Area support:
	get does a DB hit, always, no need to cache
	set stores a list we can use for persistance later
	
	Ditto for Users
	
	Edit 10 mins later. Nope, I need to hit the DB one time only, otherwise I can't set/read later for edits.
	--->
	<cffunction name="getProjectAreas" access="public" returnType="string" output="false"
				hint="Gets loci for one project.">		
		<cfset var data = "">
		
		<cfif structKeyExists(variables.instance, "projectareas")>
			<cfreturn variables.instance.projectareas>
		</cfif>
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select	p.id
			from	lh_projects_projectloci pl, 
					lh_projectloci p
			where	pl.projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getId()#" maxlength="35">
			and		pl.projectlociidfk = p.id
		</cfquery>

		<cfset variables.instance.projectareas = valueList(data.id)>
		
		<cfreturn variables.instance.projectareas>
	</cffunction>

	<cffunction name="setProjectAreas" access="public" returnType="void" output="false">
		<cfargument name="projectarealist" type="any" required="true">
		<cfset variables.instance.projectareas = arguments.projectarealist>
	</cffunction>

	<cffunction name="getFullUsers" access="public" returnType="query" output="false"
				hint="Gets users for one project. This one is more verbose and returns usernames/names">		
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select	u.id, u.username, u.name
			from	lh_projects_users pu, 
					lh_users u
			where	pu.projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getId()#" maxlength="35">
			and		pu.useridfk = u.id
		</cfquery>

		<cfreturn data>		
	</cffunction>	
		
	<cffunction name="getUsers" access="public" returnType="string" output="false"
				hint="Gets users for one project.">		
		<cfset var data = "">

		<cfif structKeyExists(variables.instance, "users")>
			<cfreturn variables.instance.users>
		</cfif>
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select	u.id
			from	lh_projects_users pu, 
					lh_users u
			where	pu.projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getId()#" maxlength="35">
			and		pu.useridfk = u.id
		</cfquery>

		<cfset variables.instance.users = valueList(data.id)>
		<cfreturn variables.instance.users>
		
	</cffunction>	

	<cffunction name="setUsers" access="public" returnType="void" output="false">
		<cfargument name="userlist" type="any" required="true">
		<cfset variables.instance.users = arguments.userlist>
	</cffunction>

	<!--- Yes, I broke my cardinal sin rule here - bad alpha order - sorry --->
	<cffunction name="getSubscribedUsers" access="public" returnType="query" output="false"
				hint="Gets all the email addresses for users subscribed to a project.">
		<cfset var data = "">
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select	u.emailaddress
			from	lh_projects_users_email pe
					, lh_users u
			where	pe.projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getId()#" maxlength="35">
			and		pe.useridfk = u.id
		</cfquery>
				
		<cfreturn data>
	</cffunction>		

	<cffunction name="setConfig" returnType="void" access="public" output="false" hint="Used to let me inject settings.">
		<cfargument name="config" type="any" required="true">
		<cfset variables.config = arguments.config>
	</cffunction>
	
</cfcomponent>	
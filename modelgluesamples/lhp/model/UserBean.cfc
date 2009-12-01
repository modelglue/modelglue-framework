<cfcomponent output="false" displayName="User Bean" hint="Manages a user instance.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.username = "" />
	<cfset variables.instance.password = "" />
	<cfset variables.instance.name = "" />	
	<cfset variables.instance.emailaddress = "" />
	<cfset variables.instance.roles = "" />

	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setUserName" returnType="void" access="public" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset variables.instance.username = arguments.username>
	</cffunction>
	
	<cffunction name="getUserName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.username>
	</cffunction>

	<cffunction name="setPassword" returnType="void" access="public" output="false">
		<cfargument name="password" type="string" required="true">
		<cfset variables.instance.password = arguments.password>
	</cffunction>
  
	<cffunction name="getPassword" returnType="string" access="public" output="false">
		<cfreturn variables.instance.password>
	</cffunction>

	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>

	<cffunction name="setRoles" returnType="void" access="public" output="false">
		<cfargument name="roles" type="string" required="true">
		<cfset variables.instance.roles = arguments.roles>
	</cffunction>
	
	<cffunction name="getRoles" returnType="string" access="public" output="false">
		<cfreturn variables.instance.roles>
	</cffunction>

	<cffunction name="setEmailAddress" returnType="void" access="public" output="false">
		<cfargument name="emailaddress" type="string" required="true">
		<cfset variables.instance.emailaddress = arguments.emailaddress>
	</cffunction>
	
	<cffunction name="getEmailAddress" returnType="string" access="public" output="false">
		<cfreturn variables.instance.emailaddress>
	</cffunction>
	
	<cffunction name="hasRole" returnType="boolean" acces="public" output="false">
		<cfargument name="role" type="string" required="true">
		<cfreturn listFindNoCase(getRoles(), arguments.role)>
	</cffunction>
	
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getUserName()))>
			<cfset arrayAppend(errors,"Username cannot be blank.")>
		</cfif>
	
		<cfif not isValid("regex", getUserName(), "[[:alnum:]|\.]+")>
			<cfset arrayAppend(errors,"Username can only contain alpha-numeric characters.")>
		</cfif>	  
		<cfif not len(trim(getEmailAddress())) or not isValid("email",getEmailAddress())>
			<cfset arrayAppend(errors,"Email address cannot be blank and must be a valid email address.")>
		</cfif>
		
		<cfif not len(trim(getPassword()))>
			<cfset arrayAppend(errors,"Password cannot be blank.")>
		</cfif>

		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

	<cffunction name="setConfig" returnType="void" access="public" output="false" hint="Used to let me inject settings.">
		<cfargument name="config" type="any" required="true">
		<cfset variables.config = arguments.config>
	</cffunction>

	<cffunction name="getProjects" access="public" returnType="string" output="false"
				hint="Gets projects for a user.">		
		<cfset var data = "">
		
		<cfif structKeyExists(variables.instance, "projects")>
			<cfreturn variables.instance.projects>
		</cfif>
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select 		p.id
			from		lh_projects p
						, lh_projects_users pu
						, lh_users u
			where p.id = pu.projectidfk
			and   pu.useridfk = u.id
			and	  u.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getID()#" maxlength="35">
		</cfquery>

		<cfset variables.instance.projects = valueList(data.id)>
		
		<cfreturn variables.instance.projects>
	</cffunction>

	<cffunction name="setProjects" access="public" returnType="void" output="false">
		<cfargument name="projectlist" type="any" required="true">
		<cfset variables.instance.projects = arguments.projectlist>
	</cffunction>	

	<cffunction name="getEmailProjects" access="public" returnType="string" output="false"
				hint="Gets email projects for a user.">		
		<cfset var data = "">
		
		<cfif structKeyExists(variables.instance, "emailprojects")>
			<cfreturn variables.instance.emailprojects>
		</cfif>
		
		<cfquery name="data" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
			select 	p.id
			from	lh_projects p, 
					lh_projects_users_email pe, 
					lh_users u
			where 	p.id = pe.projectidfk
			and   	pe.useridfk = u.id
			and	  u.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getID()#" maxlength="35">
		</cfquery>

		<cfset variables.instance.emailprojects = valueList(data.id)>
		
		<cfreturn variables.instance.emailprojects>
	</cffunction>

	<cffunction name="setEmailProjects" access="public" returnType="void" output="false">
		<cfargument name="projectlist" type="any" required="true">
		<cfset variables.instance.emailprojects = arguments.projectlist>
	</cffunction>	
		
</cfcomponent>	
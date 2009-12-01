<cfcomponent output="false" displayName="User Service">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	<cfset variables.plaintextpassword = "no">
	
	<cffunction name="init" access="public" returnType="UserService" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfargument name="userGateway" type="any" required="true">
		<cfset var config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = config.dsn>
		<cfset variables.username = config.username /> 
		<cfset variables.password = config.password />
		<cfset variables.plaintextpassword = config.plaintextpassword>
		
		<cfset variables.gateway = arguments.userGateway>
		<cfreturn this>
	</cffunction>	

	<cffunction name="authenticate" access="public" returnType="boolean" output="false"
				hint="Authenticates a user.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<Cfargument name="fromAuthString" type="boolean" default="false"/><!--- determines if the password came from the url.auth string (i.e. autologin) --->
		<cfset var auth = "">
		
		<cfquery name="auth" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select	username
			from	lh_users
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="50">
			and		password = <cfif variables.plaintextpassword OR arguments.fromAuthString> 
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="50">
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password,"SHA")#" maxlength="50">
								</cfif>
		</cfquery>
			
		<cfreturn auth.recordCount gte 1>	
	</cffunction>

	<cffunction name="deleteUsers" access="public" returnType="void" output="false">
		<cfargument name="list" type="any" required="true">
		<cfset var id = "">
		
		<cfloop index="id" list="#arguments.list#">
			<cfset variables.gateway.deleteUser(id)>
		</cfloop>
		
	</cffunction>	
	
	<cffunction name="getUser" access="public" returnType="UserBean" output="false"
				hint="Gets a user bean based on id">		
		<cfargument name="id" type="string" required="true">
		<cfif isValid("uuid",arguments.id)>
			<cfreturn variables.gateway.read(arguments.id)>
		<cfelse>
			<cfreturn variables.gateway.newUser()>
		</cfif>		
	</cffunction>
	
	<cffunction name="getUserByUsername" access="public" returnType="UserBean" output="false"
				hint="Gets a user bean based on username.">		
		<cfargument name="username" type="string" required="true">
		<cfreturn variables.gateway.readByUsername(arguments.username)>
	</cffunction>

	<cffunction name="getUsers" access="public" returnType="query" output="false"
				hint="Gets all the users.">		
		
		<cfreturn variables.gateway.getUsers()>

	</cffunction>	

	<cffunction name="saveUser" access="public" returnType="void" output="false">
		<cfargument name="user" type="any" required="true">
		<cfset variables.gateway.saveUser(arguments.user)>
	</cffunction>
	
</cfcomponent>
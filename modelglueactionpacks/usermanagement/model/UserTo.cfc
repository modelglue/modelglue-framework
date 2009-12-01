
<cfcomponent displayname="UserTO" output="false">

	<cffunction name="init" access="public" returntype="modelglueactionpacks.usermanagement.model.UserTO" output="false">
		<cfargument name="userId" type="numeric" required="false"  />
		<cfargument name="username" type="string" required="false"  />
		<cfargument name="password" type="string" required="false"  />
		<cfargument name="emailAddress" type="string" required="false"  />
		
		<cfset this.userId = arguments.userId />
		<cfset this.username = arguments.username />
		<cfset this.password = arguments.password />
		<cfset this.emailAddress = arguments.emailAddress />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>

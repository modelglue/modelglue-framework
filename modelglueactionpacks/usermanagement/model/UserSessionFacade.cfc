<cfcomponent output="false" hint="Hides interacting with session for user management purposes.">

<cffunction name="init" output="false">
	<cfargument name="userDAO" hint="Used to look up anonymous user account." />
	
	<cfset variables.anonymousUser = userDAO.readAnonymousUser() />
</cffunction>

<cffunction name="storeUser" output="false">
	<cfargument name="user" />
	
	<cfset session.user = arguments.user />
</cffunction>

<cffunction name="purgeUser" output="false">
	<cfset structDelete(session, "user") />
</cffunction>

<cffunction name="getCurrentUser" output="false">
	<cfif structKeyExists(session, "user")>
		<cfreturn session.user />
	<cfelse>
		<cfreturn variables.anonymousUser />
	</cfif>
</cffunction>

</cfcomponent>
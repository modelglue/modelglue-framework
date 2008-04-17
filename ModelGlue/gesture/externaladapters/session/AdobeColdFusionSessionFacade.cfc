<cfcomponent output="false" hint="Session facade that gets identifiers from the session scope created on Adobe-branded ColdFusion servers.  May or may not work on others.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="getSessionIdentifier" returntype="string" output="false">
	<cfif structKeyExists(session, "sessionid")>
		<cfreturn session.sessionId />
	<cfelseif structKeyExists(session, "cfid") and structKeyExists(session, "cftoken")>
		<cfset session.sessionId = "#application.name#_#session.cfid#_#session.cftoken#" />
		<cfreturn session.sessionId />
	<cfelse>
		<cfthrow type="ModelGlue.AdobeColdFusionSessionFacade.NoSessionId"
						 detail="Can't generate session identifier!"
		/>
	</cfif>
</cffunction>

</cfcomponent>

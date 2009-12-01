<cfcomponent output="false" hint="Session facade that gets identifiers from the session scope created on Adobe-branded ColdFusion servers.  May or may not work on others.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="getSessionIdentifier" returntype="string" output="false">
	<cftry>
		<cfif structKeyExists(session, "sessionid")>
			<cfreturn session.sessionId />
		<cfelseif structKeyExists(session, "cfid") and structKeyExists(session, "cftoken")>
			<cfset session.sessionId = "#application.applicationname#_#session.cfid#_#session.cftoken#" />
			<cfreturn session.sessionId />
		<cfelse>
			<cfthrow type="ModelGlue.AdobeColdFusionSessionFacade.NoSessionId"
							 detail="Can't generate session identifier!"
			/>
		</cfif>
		<cfcatch>
			<!--- 
			See if session is not enabled.  If not, build from cookie.
			
			If you've disabled that, and you're at this point in the code, please
			e-mail me to work out what you're doing, because I'd like MG to work for you.
			
			joe@firemoss.com
			--->
			<cfif structKeyExists(cfcatch, "scopeName") and cfcatch.scopeName eq "session">
				<cfreturn "#application.applicationname#_#cookie.cfid#_#cookie.cftoken#" />
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="put" output="false">
	<cfargument name="key" />
	<cfargument name="value" />

	<cftry>
		<cfset session[key] = value />
		<cfcatch>
			<!--- 
			See if session is not enabled.  If not, skip - no session for you!
			--->
			<cfif not structKeyExists(cfcatch, "scopeName") or cfcatch.scopeName neq "session">	
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="get" output="false">
	<cfargument name="key" />

	<cftry>
		<cfreturn session[key] />
		<cfcatch>
			<!--- 
			See if session is not enabled.  If not, skip - no session for you!
			--->
			<cfif not structKeyExists(cfcatch, "scopeName") or cfcatch.scopeName neq "session">	
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="exists" output="false">
	<cfargument name="key" />

	<cftry>
		<cfreturn structKeyExists(session, key) />
		<cfcatch>
			<!--- 
			See if session is not enabled.  If not, skip - no session for you!
			--->
			<cfif not structKeyExists(cfcatch, "scopeName") or cfcatch.scopeName neq "session">	
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="delete" output="false">
	<cfargument name="key" />

	<cftry>
		<cfset structDelete(session, key) />
		<cfcatch>
			<!--- 
			See if session is not enabled.  If not, skip - no session for you!
			--->
			<cfif not structKeyExists(cfcatch, "scopeName") or cfcatch.scopeName neq "session">	
				<cfrethrow />
			</cfif>
		</cfcatch>
	</cftry>
</cffunction>

</cfcomponent>

<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


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

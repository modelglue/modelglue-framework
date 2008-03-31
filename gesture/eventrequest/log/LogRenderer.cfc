<cfcomponent output="false" hint="Renders an Event Context's request log to an HTML table.">

<cffunction name="renderLog" output="false" hint="Returns an HTML representation of the request log.">
	<cfargument name="eventContext" hint="The EventContext who's log should be rendered." />
	
	<cfset var trace = arguments.eventContext.getTrace() />
	<cfset var out = "" />
	<cfset var i = "" />
	<cfset var initialTime = "" />
	<cfset var eventTime = "" />

	<!--- Shortcut to bypass.  Man, why did I ever do it like this? --->
	<cfif structKeyExists(request, "modelGlueSuppressDebugging")>
		<cfreturn "" />
	</cfif>
		
	<cfoutput>
	<cfsavecontent variable="out">
		<div clear="both">
		<h1>Model-Glue Debugging</h1>
		
		<table width="100%" cellpadding="2" cellspacing="0" border="1">
		<tr>
			<td>Time</td>
			<td>Type</td>
			<td>Message</td>
		</tr>
		<cfloop from="1" to="#arrayLen(trace)#" index="i">
			<cfif initialTime eq "">
				<cfset eventTime = 0 />
				<cfset initialTime = arguments.eventContext.getCreated() />
			<cfelse>
				<cfset eventTime = trace[i].time - initialTime />
			</cfif>
			<tr>
				<td>#eventTime#ms</td>
				<td>#trace[i].type#</td>
				<td>
					#trace[i].message#<br />
					#htmlEditFormat(trace[i].tag)#
				</td>		
			</tr>
		</cfloop>
		</table>
		</div>
	</cfsavecontent>
	</cfoutput>
	
	<cfreturn out />
</cffunction>

</cfcomponent>
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


<cfcomponent output="false" hint="Renders an Event Context's request log to an HTML table.">

<cffunction name="renderLog" output="false" hint="Returns an HTML representation of the request log.">
	<cfargument name="eventContext" hint="The EventContext who's log should be rendered." />
	
	<cfset var trace = arguments.eventContext.getTrace() />
	<cfset var out = "" />
	<cfset var i = "" />
	<cfset var initialTime = "" />
	<cfset var eventTime = "" />
	<cfset var displayedRowCount = 0 />

	<!--- mode isn't supported yet, so set to verbose --->
	<cfset var mode = "verbose">

	<cfset var colors = structNew() />	

	<cfset colors.warning = "##f4cb9a" />
	<cfset colors.trace = "##b5e1e1" />
	
	<!--- Shortcut to bypass.  Man, why did I ever do it like this? --->
	<cfif structKeyExists(request, "modelGlueSuppressDebugging") AND request.modelGlueSuppressDebugging IS true>
		<cfreturn "" />
	</cfif>
		
	<cfoutput>
	<cfsavecontent variable="out">
		<div clear="both">
		<h1>Model-Glue Debugging</h1>
		
	  <table cellpadding="2" cellspacing="2" width="100%" style="border:1px Solid ##CCC;font-family:verdana;font-size:11pt;">
		<thead>
	    <tr style="background:##EAEAEA">
	      <td style="border-bottom:1px Solid ##CCC;"><strong>Time</strong></td>
	      <td style="border-bottom:1px Solid ##CCC;" nowrap="true"><strong>Category</strong></td>
	      <td style="border-bottom:1px Solid ##CCC;"><strong>Message</strong></td>
	    </tr>
	    </thead>
	    <tbody>
		<cfloop from="1" to="#arrayLen(trace)#" index="i">
			<cfif initialTime eq "">
				<cfset eventTime = 0 />
				<cfset initialTime = arguments.eventContext.getCreated() />
			<cfelse>
				<cfset eventTime = trace[i].time - initialTime />
			</cfif>

			<cfif mode eq "verbose" or (mode eq "trace" and trace[i].traceType eq "USER")>
				<cfif trace[i].traceType eq "WARNING">
				<tr style="background:#colors.warning#" valign="top">
				<cfelseif trace[i].traceType eq "USER">
				<tr style="background:#colors.trace#" valign="top">
				<cfelseif not displayedRowCount mod 2>
				<tr style="background:##F9F9F9" valign="top">
				<cfelse>
				<tr>
				</cfif>	
					<td valign="top">#eventTime#ms</td>
					<td valign="top" nowrap="true">#trace[i].type#</td>
					<td valign="top">#trace[i].message#</td>
				</tr>
				<cfif trace[i].traceType eq "WARNING">
				<tr style="background:#colors.warning#" valign="top">
				<cfelseif trace[i].traceType eq "USER">
				<tr style="background:#colors.trace#" valign="top">
				<cfelseif not displayedRowCount mod 2>
				<tr style="background:##F9F9F9" valign="top">
				<cfelse>
				<tr valign="top">
				</cfif>	
				<td valign="top" colspan="2" style="border-bottom:1px Solid ##CCC;">&nbsp;</td>
				<td valign="top" style="font-size:9pt;border-bottom:1px Solid ##CCC;color:##666">#htmlEditFormat(trace[i].tag)#&nbsp;</td>
				</tr>
				<cfset displayedRowCount = displayedRowCount + 1 />
			</cfif>
		</cfloop>
		</tbody>
		</table>
		</div>
	</cfsavecontent>
	</cfoutput>
	
	<cfreturn out />
</cffunction>

</cfcomponent>

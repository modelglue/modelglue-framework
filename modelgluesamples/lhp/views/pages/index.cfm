<cfset root = event.getValue("myself")>
<cfset announcements = event.getValue("myannouncements")>
<cfset openissues = event.getValue("openissues")>
<cfset overdue = event.getValue("overdue")>
<cfset me = event.getValue("currentuser")>
<cfset issues = event.getValue("issues")>
<cfset projectswithissues = event.getValue("projectswithissues")>

<cfoutput>	
<h2 class="blue">Announcements</h2>
</cfoutput>

<cfset lastP = 0>
<cfset counter = 0>
<cfif announcements.recordCount>
	<cfoutput query="announcements">
	<table id="listing" class="blue" cellspacing="0">
		<cfif lastP neq project>
			<tr class="hdRow">
				<td colspan="2"><cfif len(project)>#project#<cfelse>General</cfif></td>
			</tr>
			<cfset lastP = project>
			<cfset counter = 0>
		</cfif>
		<cfset counter = counter + 1>			
		<tr <cfif counter mod 2 is 0>class="dark"</cfif>>
			<td valign="top" width="150">
				<strong class="title">#title#</strong><br/>
				#dateFormat(posted, "dddd, mmmm d, yyyy")#<br/>
				#timeFormat(posted, "hh:mm tt")#
			</td>
			<td valign="top">
			#body#							
			</td>
		</tr>								
	</table>
	</cfoutput>
<cfelse>
	<cfoutput>
	<p>There are no announcements at this time.</p>
	</cfoutput>
</cfif>	

<cfoutput>
<h2 class="red">Issues Assigned to #me.getName()#</h2>
<p class="count">#val(openissues)# Open Issue(s) | #overdue# Overdue Issue(s) | #issues.recordCount# Total</p>
</cfoutput>

<cfif issues.recordCount>
	<cfoutput>
	<table id="listing" cellspacing="0">
	</cfoutput>
	
	<!--- loop through issues, but just show 3 max --->
	<cfloop query="projectswithissues">
		<cfquery name="thisprojectissues" dbtype="query" maxrows="3">
		select	*
		from	issues
		where	projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#projectidfk#">
		</cfquery>

		<cfoutput>	
		<tr class="hdRow">
			<td colspan="8">#projectname#</td>
		</tr>
		<tr class="legendRow">
			<td>ID</td>
			<td>Name</td>
			<td>Type</td>
			<td>Area</td>
			<td>Severity</td>
			<td>Status</td>
			<td>Due</td>
			<td>Updated</td>
		</tr>
		</cfoutput>
		
		<cfloop query="thisprojectissues">
			<cfoutput>
			<tr <cfif currentRow mod 2 is 0>class="dark"</cfif>>
				<td>#publicid#</td>
				<td><a href="#root#page.viewissue&id=#id#&pid=#projectidfk#">#name#</a></td>
				<td>#issuetype#</td>
				<td>#locusname#</td>
				<td>#severityname#</td>
				<td>#statusname#</td>
				<td><cfif len(duedate)>#dateFormat(duedate,"m/d/yyy")#<cfelse>&nbsp;</cfif></td>
				<td><cfif len(updated)>#dateFormat(updated,"m/d/yyy")#<cfelse>&nbsp;</cfif></td>					
			</tr>
			</cfoutput>
		</cfloop>
	</cfloop>

<cfelse>
	<cfoutput>
	<p>
	There are no issues in any project assigned to you.
	</p>
	</cfoutput>
</cfif>
	
<cfset event.setValue("title", "Reports")>
<cfset event.setValue("selected", "reports")>
<cfset myProjects = event.getValue("myprojects")>
<cfset projects = event.getValue("projects", 0)>
<cfset root = event.getValue("myself")>

<cfset data = event.getValue("data")>
<cfset projectCollection = event.getValue("projectCollection")>
<cfset statuses = event.getValue("statuses")>
<cfset severities = event.getValue("severities")>
<cfset issuetypes = event.getValue("issuetypes")>
<cfset loci = event.getValue("loci")>
	
<h2 class="red">Reports</h2>
<p>
Select one or more projects below to generate reports.
</p>

<cfif myProjects.recordCount>

	<cfoutput>
	<form action="#root#page.reports" method="post" >
	
		<select name="projects">
		<option value="0" <cfif projects is 0>selected</cfif>>All Projects</option>
		<option value="-1" <cfif projects is -1>selected</cfif>>All Projects (My Issues)</option>
		<cfloop query="myProjects">
			<cfoutput><option value="#id#" <cfif listFind(projects,id)>selected</cfif>>#name#</option></cfoutput>
		</cfloop>
		</select>
		
		<input type="submit" name="submit_charts" value="Display Charts">
		<input type="submit" name="submit_excel" value="Excel Report">
		
	</form>
	</cfoutput>
	
<cfelse>

	<cfoutput>
	<p>
	There are no projects available for you.
	</p>
	</cfoutput>
	
</cfif>

<cfif len(event.getValue("submit_charts"))>

		<cfoutput>
		<table cellspacing="10" border="0" ><tr><td>
		</cfoutput>
				
		<cfchart showLegend="true" title="Issue Types" show3d=true>
		
			<cfloop item="pid" collection="#data#">
				<cfchartseries type="bar" seriesLabel="#projectCollection[pid].getName()#">
					<cfloop query="issuetypes">
						<cfchartdata item="#name#" value="#data[pid].issuetypes[id]#">
					</cfloop>
				</cfchartseries>

			</cfloop>
			
		</cfchart>

		<cfoutput>
		</td><td>
		</cfoutput>
	
		<cfchart showLegend="true" title="Statuses" show3d=true>
		
			<cfloop item="pid" collection="#data#">
				<cfchartseries type="bar" seriesLabel="#projectCollection[pid].getName()#">
					<cfloop query="statuses">
						<cfchartdata item="#name#" value="#data[pid].statuses[id]#">
					</cfloop>
				</cfchartseries>
			</cfloop>
			
		</cfchart>
	
		<cfoutput>
		</td></tr>
        <tr>
        <td>
		</cfoutput>

		<cfchart showLegend="true" title="Severities" show3d=true>
		
			<cfloop item="pid" collection="#data#">
				<cfchartseries type="bar" seriesLabel="#projectCollection[pid].getName()#">
					<cfloop query="severities">
						<cfchartdata item="#name#" value="#data[pid].severities[id]#">
					</cfloop>
				</cfchartseries>

			</cfloop>
			
		</cfchart>
		
		<cfoutput>
		</td>
        <td>
		</cfoutput>

		<cfchart showLegend="true" title="Issues per User" show3d=true>

			<cfloop item="pid" collection="#data#">
				<cfchartseries type="bar" seriesLabel="#projectCollection[pid].getName()#">
					<cfloop item="u" collection="#data[pid].users#">
						<cfset uname = data[pid].users[u].name>
						<cfset total = data[pid].users[u].total>
						<cfchartdata item="#uname#" value="#total#">
					</cfloop>
				</cfchartseries>

			</cfloop>

		</cfchart>
		
		<cfoutput>
		</td></tr>
        <tr><td colspan="2">
		</cfoutput>

		<cfchart showLegend="true" title="Project Areas" show3d=true chartwidth="500">
		
			<cfloop item="pid" collection="#data#">
				<cfchartseries type="bar" seriesLabel="#projectCollection[pid].getName()#">
					<cfloop query="loci">
						<cfchartdata item="#name#" value="#data[pid].loci[id]#">
					</cfloop>
				</cfchartseries>

			</cfloop>
			
		</cfchart>
		
		<cfoutput>
		</td></tr>
        </table>
		</cfoutput>
</cfif>

<cfif len(event.getValue("submit_excel"))>

	<cfset issues = event.getValue("issues")>

	<cfsetting showdebugoutput=false>
	<cfcontent TYPE="application/msexcel" reset="true">
	<cfheader name="content-disposition" value="attachment;filename=stats.xls">  

	<cfoutput>
	<table border="1">
		<tr bgcolor="yellow">
			<td filter="all"><b>Project</b></td>
			<td filter="all"><b>ID</b></td>
			<td><b>Name</b></td>
			<td filter="all"><b>Owner</b></td>
			<td filter="all"><b>Creator</b></td>
			<td filter="all"><b>Issue Type</b></td>
			<td filter="all"><b>Project Area</b></td>
			<td filter="all"><b>Severity</b></td>
			<td filter="all"><b>Status</b></td>
			<td><b>Created</b></td>
			<td><b>Updated</b></td>
			<td><b>Due Date</b></td>
		</tr>
	</cfoutput>

	<cfoutput query="issues">
		<tr>
			<td>#projectname#</td>
			<td>#publicID#</td>
			<td>#name#</td>
			<td>#username#</td>
			<td>#username#</td>
			<td>#issuetype#</td>
			<td>#locusname#</td>
			<td>#severityname#</td>
			<td>#statusname#</td>
			<td>#dateFormat(created,"mm/dd/yy")# #timeFormat(created,"hh:mm tt")#</td>
			<td>#dateFormat(updated,"mm/dd/yy")# #timeFormat(updated,"hh:mm tt")#</td>
			<td>#dateFormat(duedate,"mm/dd/yy")# #timeFormat(duedate,"hh:mm tt")#</td>
		</tr>
	</cfoutput>

	<cfoutput>
	</table>
	</cfoutput>
	<cfabort>

</cfif>
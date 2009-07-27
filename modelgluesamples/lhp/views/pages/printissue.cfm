<cfset issue = viewState.getValue("issue")>
<cfset project = viewState.getValue("project")>
<cfset issuetype = viewState.getValue("issuetype")>
<cfset projectarea = viewState.getValue("projectarea")>
<cfset severity = viewState.getValue("severity")>
<cfset status = viewState.getValue("status")>
<cfset milestone = viewState.getValue("milestone")>
<cfset owner = viewState.getValue("owner")>
<cfset creator = viewState.getValue("creator")>
	
<cfsavecontent variable="output">
<cfoutput>
<html>

<head>
</head>

<body>
<p>
<table width="90%">
	<tr>
		<td><b>Name:</b></td>
		<td>#issue.getName()#</b></td>
	</tr>
	<tr>
		<td><b>ID:</b></td>
		<td>#issue.getPublicID()#</td>
	</tr>
	<tr>
		<td><b>Project:</b></td>
		<td>#project.getName()#</td>
	</tr>
	<tr>
		<td><b>Type:</b></td>
		<td>#issuetype.getName()#</td>
	</tr>
	<tr>
		<td><b>Project Area:</b></td>
		<td>#projectarea.getName()#</td>
	</tr>
	<tr>
		<td><b>Severity:</b></td>
		<td>#severity.getName()#</td>
	</tr>
	<tr>
		<td><b>Status:</b></td>
		<td>#status.getName()#</td>
	</tr>
	<tr>
		<td><b>Due Date:</b></td>
		<td><cfif len(issue.getDueDate())>#dateFormat(issue.getDueDate(),"mm/dd/yy")# #timeFormat(issue.getDueDate(),"h:mm tt")#</cfif></td>
	</tr>
	<tr>
		<td><b>Milestone:</b></td>
		<td>#milestone.getName()#</td>
	</tr>
	<tr>
		<td><b>Related URL:</b></td>
		<td>#issue.getRelatedURL()#</td>
	</tr>
	<tr>		
		<td><b>Owner:</b></td>
		<td><cfif len(owner.getUsername())>#owner.getName()# (#owner.getUsername()#)</cfif></td>
	</tr>
	<tr>
		<td><b>Creator:</b></td>
		<td><cfif len(creator.getUsername())>#creator.getName()# (#creator.getUsername()#)</cfif></td>
	</tr>
	<tr>
		<td><b>Created:</b></td>
		<td>#dateFormat(issue.getCreated(),"mm/dd/yy")# #timeFormat(issue.getCreated(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td><b>Last Updated:</b></td>
		<td>#dateFormat(issue.getUpdated(),"mm/dd/yy")# #timeFormat(issue.getUpdated(),"h:mm tt")#</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2"><b>Description:</b><br>
		#helpers.udfs.paragraphFormat2(issue.getDescription())#</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2"><b>History:</b><br>
		#helpers.udfs.paragraphFormat2(issue.getHistory())#</td>
	</tr>

</table>
</p>

</body>
</html>
</cfoutput>
</cfsavecontent>

<cfheader name="Content-Disposition" value="inline; filename=issue.pdf">	
<cfcontent type="application/pdf" reset="true">


<cfdocument format="pdf">
<cfdocumentitem type="footer">
	<cfoutput><div style="font-family: Arial; font-size: 8px">LighthousePro - Created by Raymond Camden</div></cfoutput>
</cfdocumentitem>
		
<cfoutput>
<style>
TD { 
	font-family: Arial;
	font-size: 12px;
}
</style>
#output#
</cfoutput>

</cfdocument>	

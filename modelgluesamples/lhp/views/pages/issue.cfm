<cfset root = event.getValue("myself")>
<cfset me = event.getValue("currentuser")>
<cfset issue = event.getValue("issue")>
<cfset project = event.getValue("project")>
<cfset errors = event.getValue("errors")>
<cfset creator = event.getValue("issuecreator")>
<cfset myprojects = event.getValue("myprojects")>

<cfset name = event.getValue("name", issue.getName())>
<cfset projectidfk = event.getValue("projectidfk", issue.getProjectIdFk())>
<cfset locusidfk = event.getValue("locusidfk", issue.getLocusIdFk())>
<cfset severityidfk = event.getValue("severityidfk", issue.getSeverityIDFK())>
<cfset statusidfk = event.getValue("statusidfk", issue.getStatusIdFk())>
<cfset relatedurl = event.getValue("relatedurl", issue.getRelatedURL())>
<cfset issuetypeidfk = event.getValue("issuetypeidfk", issue.getIssueTypeIdFk())>
<cfset milestoneidfk = event.getValue("milestoeidfk", issue.getMileStoneIdFk())>
<cfset description = event.getValue("description", issue.getDescription())>
<cfset history = event.getValue("history", issue.getHistory())>
<cfset notes = event.getValue("notes")>
<cfset duedate = event.getValue("duedate", issue.getDueDate())>

<cfif not event.valueExists("useridfk")>

	<cfif issue.getId() is 0>
		<cfset useridfk = me.getId()>
	<cfelse>
		<cfset useridfk = issue.getUserIdFk()>
	</cfif>
<cfelse>
	<cfset useridfk = event.getValue("useridfk")>	
</cfif>

<!--- get loci --->
<cfset allProjectAreas = event.getValue("projectareas")> 
<cfset possibleLoci = project.getProjectAreas()> 

<!--- get statuses --->
<cfset possibleStatuses = event.getValue("statuses")>
<!--- get severities --->
<cfset possibleSeverities = event.getValue("severities")>
<!--- get issuetypes --->
<cfset possibleIssueTypes = event.getValue("issuetypes")>

<cfset milestones = event.getValue("milestones")>

<cfset possibleUsers = project.getFullUsers()>

<cfif issue.getID() is 0>
	<cfset title = "New Issue">
<cfelse>
	<cfset title = "Issue #issue.getPublicID()#: " & issue.getName()>
</cfif>

<cfset attachments = issue.getAttachments()>

<cfset event.setValue("title", title)>

<script>
$(document).ready(function() {
	$("#duedate").datepicker({showOn: 'button', buttonImage: 'images/calendar.gif', buttonImageOnly: true});
})
</script>

<cf_renderErrors errors="#errors#">

	<cfoutput>
	<h2 class="blue">#title#</h2>

	
	<div class="addLeft">
	<form action="#root#action.issuesave&pid=#project.getId()#" method="post" enctype="multipart/form-data">
	<input type="hidden" name="id" value="#issue.getId()#">
	<table id="formTable" cellspacing="4" cellpadding="4">
		<tr>
			<td align="right"><label>Project:</label></td>
			<td>
				<select name="projectidfk" id="projectidfk" class="input">
					<cfloop query="myprojects">
						<option value="#id#" <cfif id EQ project.getId()>selected</cfif>>#name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" width="120"><label>Name:</label></td>
			<td><input type="text" name="name" value="#htmlEditFormat(name)#" class="bigInput"></td>
		</tr>
		<tr>
			<td align="right" valign="top"><label>Description:</label></td>
			<td><textarea name="description" class="input" rows="12" cols="40">#htmlEditFormat(description)#</textarea></td>
		</tr>
		<tr>
			<td align="right"><label>Type:</label></td>
			<td>
			<select name="issuetypeidfk" class="input">
			<cfloop query="possibleIssueTypes">
			<option value="#id#" <cfif issuetypeidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right"><label>Project Area:</label></td>
			<td>
			<select name="locusidfk" class="input">
			<cfloop query="allProjectAreas">
				<cfif listFind(possibleLoci, id)>
					<option value="#id#" <cfif locusidfk is id>selected</cfif>>#name#</option>
				</cfif>
			</cfloop>
			</select>
			</td>
		</tr>
		<!--- Only show milestones if we have any. --->
		<cfif milestones.recordCount>
		<tr>
			<td align="right"><label>Milestone:</label></td>
			<td>
			<select name="milestoneidfk" class="input">
			<option value="" <cfif milestoneidfk is "">selected</cfif>></option>
			<cfloop query="milestones">
			<option value="#id#" <cfif milestoneidfk is id>selected</cfif>>#name#</option>
			</cfloop>	
			</select>
			</td>
		</tr>
		<cfelse>
		<input type="hidden" name="milestoneidfk" value="">
		</cfif>
		<tr>
			<td align="right"><label>Severity:</label></td>
			<td>
			<select name="severityidfk" class="input">
			<cfloop query="possibleSeverities">
			<option value="#id#" <cfif severityidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right"><label>Status:</label></td>
			<td>
			<select name="statusidfk" class="input">
			<cfloop query="possibleStatuses">
			<option value="#id#" <cfif statusidfk is id>selected</cfif>>#name#</option>
			</cfloop>
			</select>			
			</td>
		</tr>
		<tr>
			<td align="right"><label>Due Date:</label></td>
			<cfif isDate(dueDate)>
				<cfset dueDate = dateFormat(dueDate, "mm/dd/yy")>
			</cfif>
			<td><input type="text" name="duedate" id="duedate" value="#dueDate#" class="smallInput"></td>
		</tr>
		<tr>
			<td align="right"><label>Related URL:</label></td>
			<td>
			<input type="text" name="relatedurl" value="#relatedurl#" class="input">
			<cfif len(trim(relatedurl))>
			<br />
			<a target="_blank" href="#relatedurl#">Go to URL</a>
			</cfif>
			</td>
		</tr>
		<tr valign="top">
			<td align="right"><label>Attachments:</label></td>
			<td>
			<cfif structKeyExists(variables, "attachments") and isQuery(variables.attachments) and variables.attachments.recordCount gt 0>
				<cfloop query="attachments">
				<a target="_blank" href="attachments/#urlEncodedFormat(filename)#">#attachment#</a> <a href="javascript:confirmDialog('DELETE attachment - Are you sure?','#root#action.attachmentdelete&attachmentid=#id#&issue=#issue.getId()#');">[Delete]</a><br />
				</cfloop>
			<cfelse>
			No attachments.
			</cfif>
			<br />Upload New Attachment: <input type="file" name="newattachment">
			</td>
		</tr>
		<tr>
			<td align="right"><label>Owner:</label></td>
			<td>
			<select name="useridfk" class="input">
			<cfloop query="possibleUsers">
			<option value="#id#" <cfif useridfk is id>selected</cfif>>#name# (#username#)</option>
			</cfloop>
			</select>
			</td>
		</tr>
		<cfif issue.getID() neq 0>
		<tr>
			<td align="right"><label>Created:</label></td>
			<td>#dateFormat(issue.getCreated(),"mm/dd/yy")# #timeFormat(issue.getCreated(),"h:mm tt")#<cfif not isSimpleValue(creator)> by #creator.getName()# (#creator.getUsername()#)</cfif></td>
		</tr>		
		<tr>
			<td align="right"><label>Updated:</label></td>
			<td>#dateFormat(issue.getUpdated(),"mm/dd/yy")# #timeFormat(issue.getUpdated(),"h:mm tt")#</td>
		</tr>
		</cfif>
		<cfif issue.getID() is not 0>
		<tr>
			<td align="right" valign="top"><label>Add Notes:</label></td>
			<td><textarea name="notes" class="input" rows="5" cols="40">#notes#</textarea></td>
		</tr>
		<cfelse>
		<input type="hidden" name="notes" value="">
		</cfif>	
		<tr>
			<td>&nbsp;</td>
			<td>
			<input type="submit" name="Cancel" value="Cancel" class="button" />
			<cfif issue.getID() is not 0>
			<input type="submit" name="print" value="Print" class="button blue">
			<input type="submit" name="delete" value="Delete" class="button blue">
			</cfif>
			<input type="submit" name="save" value="Save" class="button blue">
			</td>
		</tr>
		
	</table>
	</div>

	<div class="addRight">
		<table id="formTable" cellpadding="0" cellspacing="0">
			<tr>
				<td><label>Issue History:</label></td>
			</tr>
			<tr>
				<td><textarea name="history" rows="25" cols="40" class="historyTxt input" readonly="true">#htmlEditFormat(history)#</textarea></td>						
			</tr>
		</table>
	</div>

</cfoutput>

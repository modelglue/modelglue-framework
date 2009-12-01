<cfset event.setValue("title", "Announcement Edit")>
<cfset root = event.getValue("myself")>
<cfset announcement = event.getValue("announcement")>

<cfset atitle = event.getValue("atitle", announcement.getTitle())>
<cfset body = event.getValue("body", announcement.getBody())>
<cfset projectidfk = event.getValue("projectidfk", announcement.getProjectIDFK())>
<cfset useridfk = event.getValue("useridfk", announcement.getUserIDFK())>

<cfset allProjects = event.getValue("projects")>
<cfset errors = event.getValue("errors")>

<h2 class="red">Announcement Edit</h2>
<p>
Use the form below to edit your announcement.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.announcementsave" method="post">
<input type="hidden" name="id" value="#announcement.getId()#">
<table id="formTable" cellspacing="4" cellpadding="4">
	<tr>
		<td align="right" width="120"><label>Title:</label></td>
		<td><input type="text" name="atitle" value="#atitle#" class="bigInput"></td>
	</tr>
	<tr>
		<td align="right"><label>Body:</label></td>
		<td><textarea name="body" class="input">#htmlEditFormat(body)#</textarea></td>
	</tr>

	<tr>
		<td align="right"><label>Project:</label></td>
		<td>
		<select name="projectidfk" class="input">
		<option value="" <cfif projectidfk is "">selected</cfif>>None</option>
		<cfloop query="allProjects">
			<cfoutput><option value="#id#" <cfif projectidfk is id>selected</cfif>>#name#</option></cfoutput>
		</cfloop>
		</select>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="Cancel" value="Cancel" class="button" /><input type="submit" name="save" value="Save" class="button blue"></td>
	</tr>
</table>
</form>
</cfoutput>


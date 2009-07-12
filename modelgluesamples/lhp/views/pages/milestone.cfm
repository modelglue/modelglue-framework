
<cfset event.setValue("title", "Milestone Edit")>
<cfset root = event.getValue("myself")>
<cfset milestone = event.getValue("milestone")>

<cfset name = event.getValue("name", milestone.getName())>
<cfset duedate = event.getValue("duedate", milestone.getDueDate())>
<cfif len(duedate)>
	<cfset duedate = dateFormat(dueDate, "mm/dd/yy")>
</cfif>		
<cfset project = event.getValue("project", milestone.getProjectIDFK())>

<cfset projects = event.getValue("projects")>
	
<cfset errors = event.getValue("errors")>

<script>
$(document).ready(function() {
	$("#duedate").datepicker({showOn: 'button', buttonImage: 'images/calendar.gif', buttonImageOnly: true});
})
</script>

<h2 class="red">Milestone Edit</h2>
<p>
Use the form below to edit this milestone.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.milestonesave" method="post">
<input type="hidden" name="id" value="#milestone.getId()#">
<table id="formTable" cellspacing="4" cellpadding="4">
	<tr>
		<td align="right" width="120"><label>Name:</label></td>
		<td><input type="text" name="name" value="#name#" class="bigInput" maxlength="50"></td>
	</tr>
	<tr>
		<td align="right"><label>Due Date:</label></td>
		<td><input type="text" name="duedate" value="#duedate#" id="duedate" class="input"></td>
	</tr>
	<tr>
		<td align="right" width="120"><label>Project:</label></td>
		<td>
		<select name="project" class="input">
		<cfloop query="projects">
		<option value="#id#" <cfif project is id>selected</cfif>>#name#</option>
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





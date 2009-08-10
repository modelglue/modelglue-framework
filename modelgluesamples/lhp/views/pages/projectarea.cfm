<cfset event.setValue("title", "Project Area Edit")>
<cfset root = event.getValue("myself")>
<cfset projectarea = event.getValue("projectarea")>

<cfset name = event.getValue("name", projectarea.getName())>

<cfset errors = event.getValue("errors")>

<h2 class="red">Project Area Edit</h2>
<p>
Use the form below to edit this project area.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.projectareasave" method="post">
<input type="hidden" name="id" value="#projectarea.getId()#">
<table id="formTable" cellspacing="4" cellpadding="4">
	<tr>
		<td align="right" width="120"><label>Name:</label></td>
		<td><input type="text" name="name" value="#name#" class="bigInput" maxlength="50"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="Cancel" value="Cancel" class="button" /><input type="submit" name="save" value="Save" class="button blue"></td>
	</tr>
</table>
</form>
</cfoutput>


<cfset event.setValue("title", "Issue Type Edit")>
<cfset root = event.getValue("myself")>
<cfset issuetype = event.getValue("issuetype")>

<cfset name = event.getValue("name", issuetype.getName())>

<cfset errors = event.getValue("errors")>

<h2 class="red">Issue Type Edit</h2>
<p>
Use the form below to edit this issue type.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.issuetypesave" method="post">
<input type="hidden" name="id" value="#issuetype.getId()#">
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


<cfset event.setValue("title", "Status Edit")>
<cfset root = event.getValue("myself")>
<cfset status = event.getValue("status")>

<cfset name = event.getValue("name", status.getName())>
<cfset rank = event.getValue("rank", status.getRank())>

<cfset errors = event.getValue("errors")>

<h2 class="red">Status Edit</h2>
<p>
Use the form below to edit this status.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.statussave" method="post">
<input type="hidden" name="id" value="#status.getId()#">
<table id="formTable" cellspacing="4" cellpadding="4">
	<tr>
		<td align="right" width="120"><label>Name:</label></td>
		<td><input type="text" name="name" value="#name#" class="bigInput" maxlength="50"></td>
	</tr>
	<tr>
		<td align="right"><label>Rank:</label></td>
		<td><input type="text" name="rank" value="#rank#" class="smallInput"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="Cancel" value="Cancel" class="button" /><input type="submit" name="save" value="Save" class="button blue"></td>
	</tr>
</table>
</form>
</cfoutput>


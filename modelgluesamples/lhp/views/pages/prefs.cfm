<cfset event.setValue("title", "Edit Preferences")>
<cfset root = event.getValue("myself")>
<cfset me = event.getValue("currentuser")>
<cfset myprojects = event.getValue("myprojects")>
<cfset name = event.getValue("name", me.getName())>
<cfset emailaddress = event.getValue("emailaddress", me.getEmailAddress())>
<cfset selprojects = me.getEmailProjects()>
<cfset errors = event.getValue("errors")>
<cfset message = event.getValue("message")>

<h2 class="red">Preferences</h2>
<p>
Use the form below to update your preferences. Every project selected in the "Email Projects" field will subscribe
you to that project. You will then get an email every time an issue is created or updated.
</p>

<cf_renderErrors errors="#errors#">
<cfif len(message)>
	<cfoutput>
		<div id="msg" class="success">
		#message#
		</div>
	</cfoutput>
</cfif>

<cfoutput>
<form action="#root#action.prefssave" method="post">
<table id="formTable" cellspacing="4" cellpadding="4">
	<tr>
		<td align="right" width="120"><label>Name:</label></td>
		<td><input type="text" name="name" value="#name#" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Email:</label></td>
		<td><input type="text" name="emailaddress" value="#emailaddress#" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>New Password:</label></td>
		<td><input type="password" name="password" value="" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Confirm Password:</label></td>
		<td><input type="password" name="password2" value="" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Email Projects:</label></td>
		<td>
		<select name="selemailProjects" multiple size="4" class="input">
		<cfloop query="myProjects">
			<cfoutput><option value="#id#" <cfif listFind(selprojects, id)>selected</cfif>>#name#</option></cfoutput>
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
	
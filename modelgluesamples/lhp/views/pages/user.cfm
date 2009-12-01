<cfset event.setValue("title", "User Edit")>
<cfset root = event.getValue("myself")>
<cfset user = event.getValue("user")>
<cfset me = event.getValue("currentuser")>
<cfset settings = event.getValue("settings")>
<cfset projects = event.getValue("projects")>

<cfset name = event.getValue("name", user.getName())>
<cfset username = event.getValue("username", user.getUserName())>
<cfset password = event.getValue("rank", user.getPassword())>
<cfset emailaddress = event.getValue("emailaddress", user.getEmailAddress())>

<cfset selProjects = event.getValue("selprojects", user.getProjects())>
<cfset selEmailProjects = event.getValue("selemailprojects", user.getEmailProjects())>

<cfset admin = event.getValue("admin", user.hasRole("admin"))>

<cfset errors = event.getValue("errors")>

<cfif user.getID() neq 0>
<script language="javascript" type="text/javascript">
 function togglepwreset(a){
 	if (a) {
 		document.getElementById("pwreset").style.display = "";
 	}
 	else {
 		document.getElementById("pwreset").style.display = "none";
 	}
 
 }
</script>
</cfif>

<h2 class="red">User Edit</h2>
<p>
Use the form below to edit a user. You may also assign a user to projects as well as subscribe them.
</p>

<cf_renderErrors errors="#errors#">

<cfoutput>
<form action="#root#action.usersave" method="post">
<input type="hidden" name="id" value="#user.getId()#">

<table id="formTable" cellspacing="4" cellpadding="4">

	<tr>
		<td align="right" width="120"><label>Username:</label></td>
		<td>
		<!--- Idea for this by Critter --->
		<cfif username is me.getUsername()>
		<input type="hidden" name="username" value="#username#">
		#username# (Username for current user cannot be changed.)
		<cfelse>
		<input type="text" name="username" value="#username#" class="bigInput" maxlength="50">
		</cfif>
		</td>
	</tr>
	<cfif not settings.plaintextpassword AND user.getID() neq 0>
		<cfset password = "">
		<tr>
			<td align="right"><label>Reset Password:</label></td>
			<td><input type="checkbox" name="resetpassword" value="true" onClick="togglepwreset(this.checked);"></td>
		</tr>
	<cfelse>
		<input type="hidden" name="resetpassword" value="true">
	</cfif>
	<tr <cfif NOT settings.plaintextpassword AND user.getID() neq 0>style="display:none;"</cfif> id="pwreset">
		<td align="right"><label>Password:</label></td>
		<td><input type="text" name="password" value="#password#" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Email:</label></td>
		<td><input type="text" name="emailaddress" value="#emailaddress#" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Name:</label></td>
		<td><input type="text" name="name" value="#name#" class="input"></td>
	</tr>
	<tr>
		<td align="right"><label>Projects:</label></td>
		<td>
		<select name="selprojects" multiple size="5" class="input">
		<cfloop query="projects">
			<cfoutput><option value="#id#" <cfif listFind(selprojects, id)>selected</cfif>>#name#</option></cfoutput>
		</cfloop>
		</select>
		</td>
	</tr>
	<tr>
		<td align="right"><label>Email Projects:</label></td>
		<td>
		<select name="emailProjects" multiple size="5" class="input">
		<cfloop query="projects">
			<cfoutput><option value="#id#" <cfif listFind(selemailprojects, id)>selected</cfif>>#name#</option></cfoutput>
		</cfloop>
		</select>
		</td>
	</tr>
	<tr>
		<td align="right"><label>Admin:</label></td>
		<td>
		<input type="radio" name="admin" <cfif admin>checked</cfif> value="yes">Yes<br />
		<input type="radio" name="admin" <cfif not admin>checked</cfif> value="no">No<br />
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="Cancel" value="Cancel" class="button" /><input type="submit" name="save" value="Save" class="button blue"></td>
	</tr>
</table>
</form>
</cfoutput>

		


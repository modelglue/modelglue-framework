<cfset users = event.getValue("users") />

<cfoutput><form action="#event.linkTo("userManagement.user.delete")#" method="post"></cfoutput>

<cfoutput>
	<div class="recordSetControls">
		<a href="#event.linkTo("userManagement.user.edit")#" class="add">Add New User</a>
		<input type="submit" value="Delete Selected Users" />
	</div>
</cfoutput>

<table class="recordSet">
<thead>
	<tr>
		<th>&nbsp;</th>
		<th>Username</th>
		<th>E-Mail Address</th>
	</tr>
</thead>
<tbody>
	<cfoutput query="users">
		<tr <cfif users.currentRow mod 2 eq 0>class="odd"<cfelse>class="even"</cfif>>
			<td class="skinny"><input type="checkbox" name="userId" value="#users.userId#" /></td>		
			<td><a href="#event.linkTo("userManagement.user.edit")##event.formatUrlParameter("userId", users.userId)#">#htmlEditFormat(users.username)#</a></td>
			<td><a href="mailto:#htmlEditFormat(users.emailAddress)#">#htmlEditFormat(users.emailAddress)#</a></td>
		</td>
	</cfoutput>
</tbody>
</table>

</form>
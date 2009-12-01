<cfset groups = event.getValue("groups") />

<cfoutput><form action="#event.linkTo("userManagement.group.delete")#" method="post"></cfoutput>

<cfoutput>
	<div class="recordSetControls">
		<a href="#event.linkTo("userManagement.group.edit")#" class="add">Add New Group</a>
		<input type="submit" value="Delete Selected Groups" />
	</div>
</cfoutput>

<table class="recordSet">
<thead>
	<tr>
		<th>&nbsp;</th>
		<th>Group</th>
	</tr>
</thead>
<tbody>
	<cfoutput query="groups">
		<tr <cfif groups.currentRow mod 2 eq 0>class="odd"<cfelse>class="even"</cfif>>
			<td class="skinny"><input type="checkbox" name="groupId" value="#groups.groupId#" /></td>		
			<td><a href="#event.linkTo("userManagement.group.edit")##event.formatUrlParameter("groupId", groups.groupId)#">#htmlEditFormat(groups.name)#</a></td>
		</td>
	</cfoutput>
</tbody>
</table>

</form>
<cfset securedModelGlueEvents = event.getValue("securedModelGlueEvents") />

<cfoutput><form action="#event.linkTo("userManagement.securedModelGlueEvent.delete")#" method="post"></cfoutput>

<cfoutput>
	<div class="recordSetControls">
		<a href="#event.linkTo("userManagement.securedModelGlueEvent.edit")#" class="add">Add New Event</a>
		<input type="submit" value="Delete Selected Events" />
	</div>
</cfoutput>

<table class="recordSet">
<thead>
	<tr>
		<th>&nbsp;</th>
		<th>Secured Model-Glue Event</th>
	</tr>
</thead>
<tbody>
	<cfoutput query="securedModelGlueEvents">
		<tr <cfif securedModelGlueEvents.currentRow mod 2 eq 0>class="odd"<cfelse>class="even"</cfif>>
			<td class="skinny"><input type="checkbox" name="eventId" value="#securedModelGlueEvents.eventId#" /></td>		
			<td><a href="#event.linkTo("userManagement.securedModelGlueEvent.edit")##event.formatUrlParameter("eventId", securedModelGlueEvents.eventId)#">#htmlEditFormat(securedModelGlueEvents.name)#</a></td>
		</td>
	</cfoutput>
</tbody>
</table>

</form>
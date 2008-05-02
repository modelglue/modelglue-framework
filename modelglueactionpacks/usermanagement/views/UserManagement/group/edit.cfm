<cfimport prefix="common" taglib="/modelglueactionpacks/common/tags" /> 

<cfset group = event.getValue("group") />

<cfset users = event.getValue("groupMembers") />
<cfset userId = event.getValue("userId") />

<cfset events = event.getValue("groupEvents") />
<cfset eventId = event.getValue("eventId") />

<cfset formSubmission = event.getValue("formSubmission", false) />
<cfset validationErrors = event.getValue("validationErrors", createObject("component", "ModelGlue.Util.ValidationErrorCollection").init()) />

<cfoutput>
<cfform action="#event.linkTo("userManagement.group.save")#">
	<input type="hidden" name="formSubmission" value="true" />
	<input type="hidden" name="groupId" value="#group.getGroupId()#" />
	<fieldset>
		<legend>Edit Group</legend>
	
		<common:formfield propertyName="name" label="Name:" required="true" validationErrors="#validationErrors#">
			<cfinput name="name" id="name" value="#group.getname()#" type="text" required="false" message="Please enter a name." />
		</common:formfield>

		<common:formfield propertyName="" showLabel="true" label="Members:">
			<fieldset>
			<cfloop query="users">
				<label for="userId_#users.userId#" class="labelCheckbox"><input type="checkbox" id="userId_#users.userId#" value="#users.userId#" name="userId" <cfif (not formSubmission and users.isMember) or listFind(variables.userId, users.userId)>checked</cfif>> #htmlEditFormat(users.username)#</label>
			</cfloop>
			</fieldset>
		</common:formfield>

		<common:formfield propertyName="" showLabel="true" label="Allowed Events:">
			<fieldset>
			<cfloop query="events">
				<label for="eventId_#events.eventId#" class="labelCheckbox"><input type="checkbox" id="eventId_#events.eventId#" value="#events.eventId#" name="eventId" <cfif (not formSubmission and events.isMember) or listFind(variables.eventId, events.eventId)>checked</cfif>> #htmlEditFormat(events.name)#</label>
			</cfloop>
			</fieldset>
		</common:formfield>

		<common:formcontrols>
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.group.list")#">Back to Group List</a>
		</common:formcontrols>
	</fieldset>
	<!---
	<fieldset>
		<p>
			<label for="name">Name:</label>
			<cfinput name="name" id="name" value="#group.getname()#" type="text" required="false" message="Please enter a name." />
			#helpers.modelglue.showErrors(validationErrors, "name")#
		</p>
		<p>
			<label>Members:</label>
			<div>
			<cfloop query="users">
				<label for="userId_#users.userId#"><input type="checkbox" id="userId_#users.userId#" value="#users.userId#" name="userId"> #htmlEditFormat(users.username)#</label>
			</cfloop>
			</div>
		</p>
		<div style="cssformcontrols">
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.group.list")#">Back to Group List</a>
		</div>
	</fieldset>
	--->
</cfform>
</cfoutput>

<cfimport prefix="common" taglib="/modelglueactionpacks/common/tags" /> 

<cfset securedModelGlueEvent = event.getValue("securedModelGlueEvent") />
<cfset validationErrors = event.getValue("validationErrors", createObject("component", "ModelGlue.Util.ValidationErrorCollection").init()) />

<cfoutput>
<cfform action="#event.linkTo("userManagement.securedModelGlueEvent.save")#">
	<input type="hidden" name="formSubmission" value="true" />
	<input type="hidden" name="eventId" value="#securedModelGlueEvent.geteventId()#" />
	<fieldset>
		<legend>Edit Secured Model-Glue Event</legend>
		<common:formfield propertyName="name" label="Name:" required="true" validationErrors="#validationErrors#">
			<cfinput name="name" id="name" value="#securedModelGlueEvent.getname()#" type="text" required="false" message="Please enter a name." />
		</common:formfield>
		<common:formcontrols>
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.securedModelGlueEvent.list")#">Back to Secured Model-Glue Event List</a>
		</common:formcontrols>
	</fieldset>
</cfform>
</cfoutput>

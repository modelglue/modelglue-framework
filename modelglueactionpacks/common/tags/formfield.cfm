<cfparam name="attributes.propertyName" type="string" />
<cfparam name="attributes.label" type="string" />
<cfparam name="attributes.required" type="boolean" default="true" />
<cfparam name="attributes.validationErrors" default="" />
<cfparam name="attributes.showLabel" type="boolean" default="true" />

<cfswitch expression="#thisTag.executionMode#">

<cfcase value="start">
<cfoutput>
		<div class="<cfif attributes.required>required</cfif> <cfif isObject(attributes.validationErrors) and attributes.validationErrors.hasErrors(attributes.propertyName)>error</cfif>">
			<cfif isObject(attributes.validationErrors) and attributes.validationErrors.hasErrors(attributes.propertyName)><p class="error">Oops!</p></cfif>
			<cfif attributes.showLabel>
				<label for="name" class="fieldLabel">#attributes.label#</label>
			</cfif>
</cfoutput>
</cfcase>
<cfcase value="end">
<cfoutput>
			<cfif isObject(attributes.validationErrors)>
				#caller.helpers.modelglue.showErrors(attributes.validationErrors, attributes.propertyName)#
			</cfif>
		</div>
</cfoutput>
</cfcase>
</cfswitch>
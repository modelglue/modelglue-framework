<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfparam name="attributes.dateFormat" type="string" default="mm/dd/yyyy" />
	<cfparam name="attributes.timeFormat" type="string" default="" />
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<cfif attributes.type eq "date">
			<cfset dateValue = dateFormat(attributes.value, attributes.dateFormat) />
			<cfif len(attributes.timeFormat) neq 0>
				<cfset dateValue = dateValue & " " & timeFormat(attributes.value, attributes.timeFormat) />
			</cfif>
			#trim(dateValue)#
		<cfelseif attributes.type eq "boolean">
			#yesNoFormat(attributes.value)#
		<cfelse>
			#attributes.value#
		</cfif>
	</span>
</div>
</cfoutput>

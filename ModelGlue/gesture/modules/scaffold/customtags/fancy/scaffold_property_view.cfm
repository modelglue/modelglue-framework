<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfparam name="attributes.dateFormat" type="string" default="m/d/yyyy" />
	<cfparam name="attributes.timeFormat" type="string" default="h:mm TT" />
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<cfif attributes.type eq "date">
			#dateFormat(attributes.value, attributes.dateFormat)# 
			<cfif len(attributes.timeFormat) neq 0>
				#timeFormat(attributes.value, attributes.timeFormat)#
			</cfif>
		<cfelseif attributes.type eq "boolean">
			#yesNoFormat(attributes.value)#
		<cfelse>
			#attributes.value#
		</cfif>
	</span>
</div>
</cfoutput>

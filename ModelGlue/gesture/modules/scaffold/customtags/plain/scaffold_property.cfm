<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfparam name="attributes.dateFormat" type="string" default="mm/dd/yyyy" />
	<cfparam name="attributes.timeFormat" type="string" default="" />
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<cfif attributes.type eq "boolean">
			<input type="radio" id="#attributes.name#_true" name="#attributes.name#" value="true"<cfif isBoolean(attributes.value) and attributes.value> checked="checked"</cfif>/>
			<label for="#attributes.name#_true"> Yes</label>
			<input type="radio" id="#attributes.name#_false" name="#attributes.name#" value="false"<cfif isBoolean(attributes.value) and not attributes.value >checked="checked"</cfif>/>
			<label for="#attributes.name#_false"> No</label>		
		<cfelseif attributes.length LTE 65535>
			<input type="text" class="input" id="#attributes.name#" name="#attributes.name#" value="<cfif attributes.type eq "date">#dateFormat(attributes.value, attributes.dateFormat)# #timeFormat(attributes.value, attributes.timeFormat)#<cfelse>#attributes.value#</cfif>" />
		<cfelse>
			<textarea class="input" id="#attributes.name#" name="#attributes.name#">#attributes.value#</textarea>
		</cfif>
	</span>
</div>
</cfoutput>


<cfset event.setValue("title", "Severities")>
<cfset severities = event.getValue("severities")>
<cfset root = event.getValue("myself")>
	

<cfoutput>
<h2 class="red">Severities</h2>
<p>
Use the form below to select a severity to edit. You may also create or delete a severity.
</p>
</cfoutput>

<cf_datatable data="#severities#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.severity" deletelink="#root#action.severitydelete" label="Severity" linkcol="name">
	<cf_datacol colname="name" label="name" />
	<cf_datacol colname="rank" label="Rank" />
</cf_datatable>



<cfset event.setValue("title", "Project Areas")>
<cfset projectareas = event.getValue("projectareas")>
<cfset root = event.getValue("myself")>
	

<h2 class="red">Project Areas</h2>
<p>
Use the form below to select a project area to modify. Project areas help you organize your issues based on what part of your project the issue was found. 
</p>
	
<cf_datatable data="#projectareas#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.projectarea" deletelink="#root#action.projectareadelete" label="Project Area" linkcol="name">
	<cf_datacol colname="name" label="name" />
</cf_datatable>


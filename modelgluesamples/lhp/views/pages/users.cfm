
<cfset event.setValue("title", "Users")>
<cfset users = event.getValue("users")>
<cfset root = event.getValue("myself")>
	

<h2 class="red">User Editing</h2>
<p>
Use the form below to select a user to modify. You may also add a new user or delete an existing user.
</p>
	
<cf_datatable data="#users#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.user" deletelink="#root#action.userdelete" label="User" linkcol="name">
	<cf_datacol colname="name" label="Name" />
	<cf_datacol colname="username" label="Username" />
	<cf_datacol colname="emailaddress" label="Email Address" format="email" />
	<!---<cf_datacol colname="admin" label="Admin" format="yesno" />--->
</cf_datatable>


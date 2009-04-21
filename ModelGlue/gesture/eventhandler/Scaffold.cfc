<cfcomponent output="false" hint="I represent a scaffold tag used to indicate generation patterns (CRUD) for a specific ORM object.">

<cfproperty name="object" type="string" hint="The ORM object to use." />
<cfproperty name="type" type="string" hint="List of generation patterns to use." />
<cfproperty name="defaultTypes" type="string" hint="List of available generation patterns." />

<cfset this.object = "" />
<cfset this.type = "" />
<cfset this.defaultTypes="list,view,edit,commit,delete" />

</cfcomponent>
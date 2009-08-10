<cfcomponent output="false" hint="I represent a value that can be set as part of a view's inclusion.">

<cfproperty name="name" type="string" hint="The name of the value." />
<cfproperty name="value" type="any" hint="The value to be set." />
<cfproperty name="overwrite" type="boolean" hint="If an existing value exists, should it be overwritten?" />

<cfset this.name = "" />
<cfset this.value = "" />
<cfset this.overwrite = true />

</cfcomponent>
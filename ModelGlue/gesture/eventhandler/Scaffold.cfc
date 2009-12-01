<cfcomponent output="false" hint="I represent a scaffold tag used to indicate generation patterns (CRUD) for a specific ORM object.">

<cfproperty name="object" type="string" hint="The ORM object to use." />
<cfproperty name="type" type="string" hint="List of generation patterns to use." />
<cfproperty name="propertyList" type="string" hint="List of available generation patterns." />
<cfproperty name="defaultTypes" type="string" hint="List of available generation patterns." />
<cfproperty name="childXML" type="array" hint="Array of XML child nodes of scaffold tag." />

<cfset this.object = "" />
<cfset this.type = "" />
<cfset this.propertyList = "" />
<cfset this.defaultTypes="list,view,edit,commit,delete" />
<cfset this.childXML = arrayNew(1) />
</cfcomponent>
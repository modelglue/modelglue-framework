<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractList" output="false" hint="I am used whever type=""list"" is used in a scaffold tag.">
<!--- Yeah yeah yeah, we need speed folks.  so default these to false--->
<cfset this.hasXMLGeneration = false />
<cfset this.hasViewGeneration = false />

<cffunction name="loadViewTemplate" output="false" access="public" returntype="string" hint="I load the CFtemplate formatted representation for this view">
	<!--- Each of these parameters is also available for the second pass of generation under the metadata scope, 
			On the First Pass, use #arguments#
			On the Second Pass use %metadata.advice% 
			--->
	<cfargument name="advice" type="struct" required="true"/>
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="class" type="string" required="true"/>
	<cfargument name="orderedpropertylist" type="string" required="true"/>
	<cfargument name="prefix" type="string" required="true"/>
	<cfargument name="primarykeylist" type="string" required="true"/>
	<cfargument name="properties" type="struct" required="true"/>
	<cfargument name="propertylist" type="string" required="true"/>
	<cfargument name="suffix" type="string" required="true"/> 
	<cfset var copyToScopeList = listSort(listAppend("myself,#arguments.alias#Query,xe.delete,xe.edit,xe.list,xe.view", arguments.primaryKeyList ),  "textnocase" ) />
	<cfreturn  ('
<<cfoutput>>
<cfsilent>
	<cfset event.copyToScope( variables, "#copyToScopeList#" )/>
	<cfset editEvent = myself & xe.edit />
</cfsilent>
<cfoutput>
<div id="breadcrumb">%spaceCap( Metadata.alias )% / <a href="##editEvent##">Add New %spaceCap( Metadata.alias )%</a></div>
<br />
<mg:scaffold_list name="%Metadata.alias%" displayPropertyList="%getDisplayPropertyList(Metadata.orderedpropertylist,Metadata)%" primaryKeyList="%Metadata.primaryKeyList%" theList="##%Metadata.alias%Query##"
	viewEvent="##myself & xe.view##" editEvent="##editEvent##" deleteEvent="##myself & xe.delete##" />
</cfoutput>
<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""grid"" is used in a scaffold tag.">

<cffunction name="makeModelGlueXMLFragment" output="false" access="public" returntype="string" hint="I make an instance of a modelglue xml fragment for this event">
	<cfargument name="advice" type="struct" required="true"/>
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="class" type="string" required="true"/>
	<cfargument name="orderedpropertylist" type="string" required="true"/>
	<cfargument name="prefix" type="string" required="true"/>
	<cfargument name="primarykeylist" type="string" required="true"/>
	<cfargument name="properties" type="struct" required="true"/>
	<cfargument name="propertylist" type="string" required="true"/>
	<cfargument name="suffix" type="string" required="true"/> 
	<cfset var xml = '
		<event-handler name="#arguments.alias#.Grid" access="public"' />
	
	<cfif len(arguments.eventtype)>
		<cfset xml = xml & ' type="#arguments.eventtype#"' />
	</cfif>
	
	<cfset xml = xml & '>'/>	
	<cfset xml = xml & ('			
			<broadcasts>
				<message name="ModelGlue.genericList">
					<argument name="criteria" value="" />
					<argument name="object" value="#arguments.alias#" />
					<argument name="queryName" value="#arguments.alias#Query" />
				</message>
			</broadcasts>
			<views>
				<view name="body" template="#arguments.prefix##arguments.alias##arguments.suffix#" append="true">
					<value name="xe.delete" value="#arguments.alias#.Delete" overwrite="true" />
					<value name="xe.edit" value="#arguments.alias#.Edit" overwrite="true" />
					<value name="xe.list" value="#arguments.alias#.List" overwrite="true" />
					<value name="xe.view" value="#arguments.alias#.View" overwrite="true" />
				</view>
			</views>
		</event-handler>
		') />			
	<cfreturn xml />
</cffunction>
 	
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
	<cfset deleteEvent = myself & xe.delete  />
	<cfset editEvent = myself & xe.edit  />
	<cfset listEvent = myself & xe.list  />
	<cfset viewEvent = myself & xe.view  />
	<cfsavecontent variable="dataTablesInit"> <!--- Datatables jquery requirements --->
		<style type="text/css" title="currentStyle">
			@import "www/css/datatables.css";
		</style>
		<script type="text/javascript" language="javascript" src="www/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/js/jquery.dataTables.min.js"></script>
		<script type="text/javascript" charset="utf-8">
			$(document).ready(function() { 	$("##mgGrid").dataTable(); } );

		</script>
	</cfsavecontent>
	<cfhtmlhead text="##dataTablesInit##">	
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="##listEvent##">Grid %spaceCap( Metadata.alias )%</a></div>
<br />
<div>
<table id="mgGrid">
	<thead>
		<tr>
		 <<cfloop list="%Metadata.orderedPropertyList%"  index="thisProp">>
		 	<<cfif listFindNoCase(Metadata.primaryKeyList , thisProp) IS false>>
	 			<th>%spaceCap(thisProp)%</th>
			<</cfif>>
		<</cfloop>>
			<th>&nbsp;</th>	
			<th>&nbsp;</th>	
		</tr>
	</thead>
	<tbody>
    <cfloop query="%Metadata.alias%Query">
		<tr>	
    <<cfloop list="%Metadata.orderedPropertyList%"  index="thisProp">>
		<<cfif listFindNoCase(Metadata.primaryKeyList, thisProp) IS false>>
        	<td><a href="##viewEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">##%Metadata.alias%Query.%thisProp%##</a></td>
		<</cfif>>
	<</cfloop>>
			<td><a href="##editEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">Edit</a></td>
			<td><a href="##deleteEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">Delete</a></td>
		</tr>
	</cfloop>
	</tbody>
</table>
</div>
</cfoutput>
<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

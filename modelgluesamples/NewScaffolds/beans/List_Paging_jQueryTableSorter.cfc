<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""list"" is used in a scaffold tag.">
<!--- Yeah yeah yeah, we need speed folks.  so default these to false--->
<cfset this.hasXMLGeneration = false />
<cfset this.hasViewGeneration = false />

<cffunction name="makeModelGlueXMLFragment" output="false" access="public" returntype="string" hint="I make an instance of a modelglue xml fragment for this event">
	<cfargument name="advice" type="struct" required="true"/>
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="class" type="string" required="true"/>
	<cfargument name="eventtype" type="string" required="true"/>
	<cfargument name="orderedpropertylist" type="string" required="true"/>
	<cfargument name="prefix" type="string" required="true"/>
	<cfargument name="primarykeylist" type="string" required="true"/>
	<cfargument name="properties" type="struct" required="true"/>
	<cfargument name="propertylist" type="string" required="true"/>
	<cfargument name="suffix" type="string" required="true"/>

	<cfset var xml = '
		<event-handler name="#arguments.alias#.List" access="public"' />
	
	<cfif len(arguments.eventtype)>
		<cfset xml = xml & ' type="#arguments.eventtype#"' />
	</cfif>
	
	<cfset xml = xml & '>
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
'>
	
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
	<cfset variables.deleteEvent = myself & xe.delete  />
	<cfset variables.editEvent = myself & xe.edit  />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.viewEvent = myself & xe.view  />
	<cfsavecontent variable="tableSorterInit"> <!--- TableSorter jquery requirements --->
		<style type="text/css" title="currentStyle">
			@import "www/themes/blue/style.css";
		</style>
		<script type="text/javascript" language="javascript" src="www/js/jquery-1.3.2.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/js/jquery.tablesorter.min.js"></script>
		<script type="text/javascript" language="javascript" src="www/addons/pager/jquery.tablesorter.pager.js"></script>
		<script type="text/javascript" charset="utf-8">
		$(document).ready(function() {
			$("table.tablesorter")
				.tablesorter({widthFixed: true, widgets: ["zebra"]})
				.tablesorterPager({container: $("##pager")});
		});
		</script>
	</cfsavecontent>
	<cfhtmlhead text="##tableSorterInit##">	
</cfsilent>
<cfoutput>
<div id="breadcrumb">%spaceCap( Metadata.alias )% / <a href="##editEvent##">Add New %spaceCap( Metadata.alias )%</a></div>
<br />
<table class="tablesorter">
    <thead>
	<tr>
	 <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
	 	<<cfif listFindNoCase(Metadata.primaryKeyList , thisProp) IS false AND Metadata.properties[thisProp].relationship IS false AND (not structKeyExists(Metadata.properties[thisProp],"_persistent") or Metadata.properties[thisProp]._persistent is true)>>
 			<th>%spaceCap(thisProp)%</th>
		<</cfif>>
	<</cfloop>>
		<th>&nbsp;</th>	
		<th>&nbsp;</th>	
	</tr>
    </thead>
    <tfoot>
	<tr>
	 <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
	 	<<cfif listFindNoCase(Metadata.primaryKeyList , thisProp) IS false AND Metadata.properties[thisProp].relationship IS false AND (not structKeyExists(Metadata.properties[thisProp],"_persistent") or Metadata.properties[thisProp]._persistent is true)>>
 			<th>%spaceCap(thisProp)%</th>
		<</cfif>>
	<</cfloop>>
		<th>&nbsp;</th>	
		<th>&nbsp;</th>	
	</tr>
    </tfoot>
    <tbody>
    <cfloop query="%Metadata.alias%Query">
		<tr>	
    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
		<<cfif listFindNoCase( Metadata.primaryKeyList, thisProp ) IS false AND Metadata.properties[thisProp].relationship IS false AND (not structKeyExists(Metadata.properties[thisProp],"_persistent") or Metadata.properties[thisProp]._persistent is true)>>
        	<td><a href="##viewEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">##%Metadata.alias%Query.%thisProp%##</a></td>
		<</cfif>>
	<</cfloop>>
			<td><a href="##editEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">Edit</a></td>
			<td><a href="##deleteEvent##%makeQuerySourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%">Delete</a></td>
		</tr>
	</cfloop>
    </tbody>
</table>
<div id="pager" class="pager">
	<form>
		<img src="www/addons/pager/icons/first.png" class="first"/>
		<img src="www/addons/pager/icons/prev.png" class="prev"/>
		<input type="text" class="pagedisplay"/>
		<img src="www/addons/pager/icons/next.png" class="next"/>
		<img src="www/addons/pager/icons/last.png" class="last"/>
		<select class="pagesize">
			<option selected="selected"  value="10">10</option>
			<option value="20">20</option>
			<option value="30">30</option>
			<option  value="40">40</option>
		</select>
	</form>
</div>
</cfoutput>
<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

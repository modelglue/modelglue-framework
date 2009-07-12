<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""edit"" is used in a scaffold tag.">

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
	<cfreturn ('
		<event-handler name="#arguments.alias#.Edit" access="public">
			<broadcasts>
				<message name="ModelGlue.genericRead">
					<argument name="criteria" value="#arguments.primaryKeyList#" />
					<argument name="object" value="#arguments.alias#" />
					<argument name="recordName" value="#arguments.alias#Record" />
				</message>
			</broadcasts>
			<views>
				<view name="body" template="#arguments.prefix##arguments.alias##arguments.suffix#" append="true">
					<value name="xe.commit" value="#arguments.alias#.Commit" overwrite="true" />
					<value name="xe.list" value="#arguments.alias#.List" overwrite="true" />
				</view>
			</views>
			<results>
			</results>
		</event-handler>
')>
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
	<cfset var copyToScopeList = listSort(listAppend("myself,#arguments.alias#Record,xe.commit,xe.edit,xe.list", arguments.primaryKeyList ),  "textnocase" ) />
	<cfreturn  ('<cfsilent>
<<cfoutput>>
	<cfset event.copyToScope( variables, "#copyToScopeList#" )/>
	<cfset variables.commitEvent = "##myself####xe.commit##%makeBeanSourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%" />
	<cfset variables.editEvent = myself & xe.edit  />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.hasErrors = false />
	<cfset variables.validation = event.getValue("%Metadata.alias%Validation", structNew() ) />
	<cfset variables.isNew = true />
	<cfif NOT structIsEmpty( validation ) >
		<cfset variables.hasErrors = true />
	</cfif>	
	<cfif  %makePrimaryKeyCheckForIsNew( Metadata.alias, Metadata.primaryKeyList )% >
		<cfset variables.isNew = false />
	</cfif>
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="##listEvent##">%spaceCap( Metadata.alias )%</a> / <cfif isNew>Add New<cfelse>Edit</cfif> %spaceCap( Metadata.alias)%
</div>
<cfif hasErrors IS true>
<h2>Submission Errors</h2>
<ul>
	<cfloop collection="##validation##" item="variables.field">
	<li>##arrayToList(validation["##field##"])##</li>
	</cfloop>
</ul>
</cfif>
<br />
<table>
<cfform action="##commitEvent##" class="edit">
%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
		<<cfif listFindNoCase(Metadata.primaryKeyList , thisProp) IS false>>
		<tr>	
        	<td>%spaceCap( thisProp )%</td><td><input type="text" name="%thisProp%" value="##%Metadata.alias%Record.get%thisProp%()##"></td>
		</tr>
		<</cfif>>
	<</cfloop>>
		<tr>
			<td colspan="2"><input type="submit" name="submit" value=" Save %thisProp% ">
		</tr>
</table>
</cfform>
</cfoutput>
<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""edit"" is used in a scaffold tag.">

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
	
	<cfset var relationshipMessages = "" />
	<cfset var thisProp = "" />
	<cfset var knownRelationships = "" />
	<cfset var xml = "" />
	
	<cfloop collection="#arguments.properties#" item="thisProp">
		<cfif arguments.properties[thisProp].relationship IS true AND listfind( knownRelationships, thisProp ) IS false>
			<cfset relationshipMessages = '#relationshipMessages#
				<message name="ModelGlue.genericList">
					<argument name="object" value="#arguments.properties[thisProp].sourceObject#" />
					<argument name="queryName" value="#arguments.properties[thisProp].sourceObject#List" />
					<argument name="criteria" value="" />
				</message>'>
		<cfset knownRelationships = listAppend(knownRelationships, thisProp) />
		</cfif>
	</cfloop>
	
	<cfset xml = '
		<event-handler name="#arguments.alias#.Edit" access="public"' />
	
	<cfif len(arguments.eventtype)>
		<cfset xml = xml & ' type="#arguments.eventtype#"' />
	</cfif>
	
	<cfset xml = xml & '>
			<broadcasts>
				<message name="ModelGlue.genericRead">
					<argument name="criteria" value="#arguments.primaryKeyList#" />
					<argument name="object" value="#arguments.alias#" />
					<argument name="recordName" value="#arguments.alias#Record" />
				</message>#relationshipMessages#
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
	<cfargument name="ormName" type="string" required="true"/> 
	<cfset var copyToScopeList = listSort(listAppend("myself,#arguments.alias#Record,xe.commit,xe.edit,xe.list", arguments.primaryKeyList ),  "textnocase" ) />
	
	<cfreturn  ('<cfsilent>
<<cfoutput>>
	<cfset event.copyToScope( variables, "#copyToScopeList#" )/>
	<cfset variables.commitEvent = "##myself####xe.commit##" />
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
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="##listEvent##">%spaceCap( Metadata.alias )%</a> / <cfif isNew>Add New<cfelse>Edit</cfif> %spaceCap( Metadata.alias )%
</div>
<cfif hasErrors IS true>
<h2>Submission Errors</h2>
<ul>
	<cfloop collection="##validation##" item="variables.field">
	<li>##arrayToList(validation[field])##</li>
	</cfloop>
</ul>
</cfif>
<br />
<table>
<cfform action="##commitEvent##" class="edit">
%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
		<<cfif %isDisplayProperty(thisProp,Metadata)%>>
			<cf_scaffold_property name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="##%Metadata.alias%Record.get%thisProp%()##" length="%Metadata.properties[thisProp].length%" event="##event##" />
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS false >>
			<cf_scaffold_manytoone name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
				valueQuery="##event.getValue(''%Metadata.properties[thisProp].sourceobject%List'')##"
				childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
				value="##variables.ormAdapter.getSourceValue(%Metadata.alias%Record,''%Metadata.properties[thisProp].alias%'',''%Metadata.properties[thisProp].sourcekey%'',event)##"
				nullable="%getIsNullable(Metadata.properties[thisProp])%" objectName="%Metadata.alias%" validation="##validation##" />
	<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS true >>
		<cf_scaffold_manytomany name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
			valueQuery="##event.getValue(''%Metadata.properties[thisProp].sourceobject%List'')##"
			selectedList="##variables.ormAdapter.getSelectedList(event,%Metadata.alias%Record,''%thisProp%'',''%Metadata.properties[thisProp].sourceKey%'')##"
			childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
			value="##variables.ormAdapter.getSourceValue(%Metadata.alias%Record,''%Metadata.properties[thisProp].alias%'',''%Metadata.properties[thisProp].sourcekey%'',event)##"
			nullable="%getIsNullable(Metadata.properties[thisProp])%" objectName="%Metadata.alias%" />
		<</cfif>>  
	<</cfloop>>
	<tr>
		<td colspan="2"><input type="submit" name="submit" value=" Save %Metadata.alias% "></td>
	</tr>
</cfform>
</table>
</cfoutput>

<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


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
	<cfset var copyToScopeList = listSort(listAppend("myself,#arguments.alias#Record,CFUniformConfig,xe.commit,xe.edit,xe.list", arguments.primaryKeyList ),  "textnocase" ) />
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
	
	<cfset event.addCSSAssetFile( "ui/css/smoothness/jquery-ui-1.8.custom.css" ) />
	<cfset event.addCSSAssetFile( "multiSelect/css/jquery.multiselect.css" ) />
	<cfset event.addCSSAssetFile( "scaffold/css/edit.css" ) />
	
	<cfset event.addJSAssetFile( "core/jquery-1.4.2.min.js" ) />
	<cfset event.addJSAssetFile( "ui/js/jquery-ui-1.8.custom.min.js" ) />
	<cfset event.addJSAssetFile( "multiSelect/js/jquery.multiselect.min.js" ) />
	<cfset event.addJSAssetFile( "scaffold/js/edit.js" ) />
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
<div class="cfUniForm-form-container">
	<uform:form action="##commitEvent##" id="frmMain" attributecollection="##CFUniformConfig##" submitValue=" Save %Metadata.alias% " cssLoadVar="uformCSS" jsLoadVar="uformJS">
	%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
		<uform:fieldset legend="">
		    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>

				<<cfif %isDisplayProperty(thisProp,Metadata)%>>
					<mg:scaffold_property name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
						value="##%Metadata.alias%Record.get%thisProp%()##" length="%Metadata.properties[thisProp].length%" event="##event##" />

				<<cfelseif Metadata.properties[thisProp].relationshiptype IS "many-to-one" >>
					<mg:scaffold_manytoone name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
						valueQuery="##event.getValue(''%Metadata.properties[thisProp].sourceobject%List'')##"
						childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
						value="##variables.ormAdapter.getSourceValue(%Metadata.alias%Record,''%Metadata.properties[thisProp].alias%'',''%Metadata.properties[thisProp].sourcekey%'',event)##"
						nullable="%getIsNullable(Metadata.properties[thisProp])%" objectName="%Metadata.alias%" validation="##validation##" />

				<<cfelseif Metadata.properties[thisProp].relationshiptype IS "one-to-one">>
					<<!--- do a one-to-one --->>
					<<cfset otoMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
					<<cfset otoMetadata.primaryKeyList = arrayToList(otoMetadata.primaryKeys) />>
					<<cfset otoMetadata.alias = thisProp />>
					<cfset %otoMetadata.alias%Record = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%() />
				    <<cfloop list="%otoMetadata.orderedPropertyList%"  index="otoProp">>
						<<cfif %isDisplayProperty(otoProp,otoMetadata)%>>
							<mg:scaffold_property name="%otoProp%" label="%Metadata.properties[otoProp].label%" type="%Metadata.properties[otoProp].cfdatatype%"
								value="##%Metadata.alias%Record.get%otoProp%()##" length="%Metadata.properties[otoProp].length%" event="##event##" />
						<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "many-to-one">>
							<mg:scaffold_manytoone name="%otoMetadata.properties[otoProp].sourceKey%" label="%otoMetadata.properties[otoProp].label%"
								valueQuery="##event.getValue(''%otoMetadata.properties[otoProp].sourceobject%List'')##"
								childDescProperty="%otoMetadata.properties[otoProp].sourcecolumn%"
								value="##variables.ormAdapter.getSourceValue(%otoMetadata.alias%Record,''%otoMetadata.properties[otoProp].alias%'',''%otoMetadata.properties[otoProp].sourcekey%'',event)##"
								nullable="%getIsNullable(otoMetadata.properties[otoProp])%" objectName="%otoMetadata.alias%" validation="##validation##" />
						<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "one-to-one">>
							<<!--- its a one-to-one - skip it --->>
						<<cfelseif otoMetadata.properties[otoProp].relationship IS true AND otoMetadata.properties[otoProp].pluralrelationship IS true >>
							<<!--- this is for one-to-many and many-to-many - *** todo ***
							<<cfset childotoMetadata = %findOrmAdapter().getObjectotoMetadata(otoMetadata.properties[otoProp].sourceObject)% />>
							<<cfset childotoMetadata.primaryKeyList = arrayToList(childotoMetadata.primaryKeys) />>
							<mg:scaffold_list name="%otoProp%" label="%otoMetadata.properties[otoProp].label%" 
								displayPropertyList="%getDisplayPropertyList(structKeyList(childotoMetadata.properties),childotoMetadata)%"
								primaryKeyList="%childotoMetadata.primaryKeyList%"
								theList="##variables.ormAdapter.getChildCollection(%otoMetadata.alias%Record,''%otoProp%'')##"
								viewEvent="##myself##%otoMetadata.properties[otoProp].sourceObject%.View" editEvent="##myself##%otoMetadata.properties[otoProp].sourceObject%.Edit" deleteEvent="##myself##%otoMetadata.properties[otoProp].sourceObject%.Delete"
								record="##%otoMetadata.alias%Record##" parentPKList="%otoMetadata.primarykeylist%" />
							--->>
						<</cfif>>  
					<</cfloop>>

				<<cfelseif Metadata.properties[thisProp].relationshiptype IS "one-to-many" >>
					<<cfset childMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
					<<cfset childMetadata.primaryKeyList = arrayToList(childMetadata.primaryKeys) />>
					<mg:scaffold_list name="%thisProp%" label="%Metadata.properties[thisProp].label%" 
						displayPropertyList="%getDisplayPropertyList(structKeyList(childMetadata.properties),childMetadata)%"
						primaryKeyList="%childMetadata.primaryKeyList%"
						theList="##variables.ormAdapter.getChildCollection(%Metadata.alias%Record,''%thisProp%'')##"
						viewEvent="##myself##%Metadata.properties[thisProp].sourceObject%.View" editEvent="##myself##%Metadata.properties[thisProp].sourceObject%.Edit" deleteEvent="##myself##%Metadata.properties[thisProp].sourceObject%.Delete"
						record="##%Metadata.alias%Record##" parentPKList="%Metadata.primarykeylist%" onEditForm="true" />
	
				<<cfelseif Metadata.properties[thisProp].relationshiptype IS "many-to-many" >>
					<mg:scaffold_manytomany name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
						valueQuery="##event.getValue(''%Metadata.properties[thisProp].sourceobject%List'')##"
						selectedList="##variables.ormAdapter.getSelectedList(event,%Metadata.alias%Record,''%thisProp%'',''%Metadata.properties[thisProp].sourceKey%'')##"
						childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
						objectName="%Metadata.alias%" />
				<</cfif>>  
			<</cfloop>>
		</uform:fieldset>
	</uform:form>
	
	<cfset event.addCSSAssetCode( uformCSS ) />
	<cfset event.addJSAssetCode( uformJS ) />
</div>
</cfoutput>

<</cfoutput>>
')>	
</cffunction>

</cfcomponent>

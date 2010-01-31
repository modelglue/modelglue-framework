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
	
	<cfset var xml = '
		<event-handler name="#arguments.alias#.View" access="public"' />
	
	<cfif len(arguments.eventtype)>
		<cfset xml = xml & ' type="#arguments.eventtype#"' />
	</cfif>
	
	<cfset xml = xml & '>
			<broadcasts>
				<message name="ModelGlue.genericRead">
					<argument name="criteria" value="#arguments.primaryKeyList#" />
					<argument name="object" value="#arguments.alias#" />
					<argument name="recordName" value="#arguments.alias#Record" />
				</message>
			</broadcasts>
			<views>
				<view name="body" template="#arguments.prefix##arguments.alias##arguments.suffix#" append="true">
					<value name="xe.list" value="#arguments.alias#.List" overwrite="true" />
				</view>
			</views>
			<results>
			</results>
		</event-handler>
'>
	
	<cfreturn xml />
</cffunction>

 	
<cffunction name="loadViewTemplate" output="false" access="public" returntype="any" hint="I load the CFtemplate formatted representation for this view">
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
	<cfreturn  ('
<<cfoutput>>
<cfsilent>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%record,xe.list") />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="##listEvent##">%spaceCap( Metadata.alias )%</a> / View %spaceCap( Metadata.alias )%</div>
<br />
<form class="edit"> 
<fieldset>
    <<cfloop list="%Metadata.orderedPropertyList%"  index="thisProp">>
		<<cfif %isDisplayProperty(thisProp,Metadata)%>>
			<cf_scaffold_property_view name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="##%Metadata.alias%Record.get%thisProp%()##" />
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS false >>
			<cf_scaffold_property_view name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="##variables.ormAdapter.getSourceValue(%Metadata.alias%Record,''%Metadata.properties[thisProp].alias%'',''%Metadata.properties[thisProp].sourcecolumn%'')##" />
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS true >>
			<<cfset childMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
			<<cfset childMetadata.primaryKeyList = arrayToList(childMetadata.primaryKeys) />>
			<cf_scaffold_list name="%thisProp%" label="%Metadata.properties[thisProp].label%" 
				displayPropertyList="%getDisplayPropertyList(structKeyList(childMetadata.properties),childMetadata)%"
				primaryKeyList="%childMetadata.primaryKeyList%"
				theList="##variables.ormAdapter.getChildCollection(%Metadata.alias%Record,''%thisProp%'')##"
				viewEvent="##myself##%Metadata.properties[thisProp].sourceObject%.View" editEvent="##myself##%Metadata.properties[thisProp].sourceObject%.Edit" deleteEvent="##myself##%Metadata.properties[thisProp].sourceObject%.Delete"
				record="##%Metadata.alias%Record##" parentPKList="%Metadata.primarykeylist%" />
		<</cfif>>  
	<</cfloop>>
</fieldset>
</form>
</cfoutput>
<</cfoutput>>
')>	

</cffunction>
	
</cfcomponent>

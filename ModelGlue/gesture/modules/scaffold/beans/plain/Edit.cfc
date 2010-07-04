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

</cfcomponent>

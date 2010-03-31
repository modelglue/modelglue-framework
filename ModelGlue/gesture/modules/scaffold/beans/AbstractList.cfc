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
 	
</cfcomponent>

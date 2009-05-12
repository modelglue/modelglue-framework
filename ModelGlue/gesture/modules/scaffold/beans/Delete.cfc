<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""delete"" is used in a scaffold tag.">

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
		<event-handler name="#arguments.alias#.Delete" access="public">
			<broadcasts>
				<message name="ModelGlue.genericDelete">
					<argument name="criteria" value="#arguments.primaryKeyList#" />
					<argument name="object" value="#arguments.alias#" />
				</message>
			</broadcasts>
			<views>
			</views>
			<results>
				<result name="" do="#arguments.alias#.List" redirect="true" append="" preserveState="false" />
			</results>
		</event-handler>					
')>
</cffunction>


<cffunction name="loadMetadata" output="false" access="public" returntype="struct" hint="I load the metadata for this scaffold">
	<cfreturn variables._metadata />	
</cffunction>	

<cffunction name="loadViewTemplate" output="false" access="public" returntype="string" hint="I load the CFtemplate formatted representation for this view">
	<cfreturn this />
</cffunction>
</cfcomponent>


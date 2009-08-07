<!--- 
	If you are looking at this, then you probably want to extend scaffolds. Good for you. Here is some helpful bits for you.
	
	The Properties Struct:
	You can pull the following information about the ORM object by accessing the Properties Struct.
	Valid Keys:
		COMMENT
		LABEL
		LINKINGRELATIONSHIP
		PLURALRELATIONSHIP
		RELATIONSHIP
		SOURCECOLUMN
		SOURCEKEY
		SOURCEOBJECT
		alias
		cfDataType
		cfSqlType
		dbDataType
		default
		identity
		length
		name
		nullable
		object
		primaryKey
		readOnly
		scale
		sequence 	

 --->
<cfcomponent output="false"  hint="I am the base class for Scaffolds. Extend me for fun and profit" >
<!--- Yeah yeah yeah, we need speed folks.  so default these to false--->
<cfset this.hasXMLGeneration = false />
<cfset this.hasViewGeneration = false />

<cffunction name="init" output="false" hint="I configure a scaffold from the mgframework">
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="primaryKeys" type="array" required="false" default="#arrayNew(1)#"/>
	<cfargument name="hasXMLGeneration" required="false" default="false"/>
	<cfargument name="hasViewGeneration" required="false" default="false"/>
	<cfargument name="prefix" required="false" default=""/>
	<cfargument name="suffix" required="false" default=""/>
	<cfargument name="class" required="false" default=""/>
	<cfargument name="properties" required="false" default="false"/>
	<cfargument name="propertylist" required="false" default=""/>
	<cfargument name="eventType" required="false" default=""/>
	<cfargument name="advice" required="false" default="#structNew()#"/>
	<cfset var metadata = structNew() />
	<cfset metadata.alias = arguments.alias />
	<cfset metadata.primaryKeyList = arrayToList( arguments.primaryKeys ) />
	<cfset metadata.prefix = arguments.prefix  />
	<cfset metadata.suffix = arguments.suffix />
	<cfset metadata.class = arguments.class />
	<cfset metadata.properties = arguments.properties />
	<cfset metadata.propertylist =listSort(  structKeyList( metadata.properties ), "textnocase" ) />
	<cfif listLen( arguments.propertylist ) GT 0>
		<cfset metadata.propertylist = arguments.propertylist />
	</cfif>
	<!--- This one should be in order for sure. Either alphabetical or userdefined --->
	<cfset metadata.orderedPropertyList = metadata.propertylist />
	<cfset metadata.eventType = arguments.eventType />
	<cfset metadata.advice = arguments.advice />
	<cfset beforeMetadataLoaded( metadata ) />
	<cfset this.hasXMLGeneration = arguments.hasXMLGeneration />
	<cfset this.hasViewGeneration = arguments.hasViewGeneration />
	<cfreturn this />
</cffunction>
	
<cffunction name="makeFullFilePathAndNameForView" output="false" access="public" returntype="string" hint="I make the full file path where this object should persist the views">
	<cfargument name="pathPrefix" type="string" required="true"/>
	<cfreturn "#arguments.pathPrefix#/#variables._metadata.prefix##variables._metadata.alias##variables._metadata.suffix#" />	
</cffunction>

<cffunction name="makeMGXMLWithMetadata" output="false" access="public" returntype="string" hint="I make generated xml in ModelGlue format for a specific scaffold.">
	<cfreturn makeModelGlueXMLFragment( argumentcollection:variables._metadata ) />
</cffunction>

<cffunction name="loadViewTemplateWithMetadata" output="false" access="public" returntype="any" hint="I load the viewtemplate with the metadata">
	<cfreturn	 loadViewTemplate( argumentcollection:variables._metadata ) />
</cffunction>

<cffunction name="loadViewTemplate" output="false" access="public" returntype="string" hint="I make generated HTML according to my configured format for a specific scaffold.">
	<cfreturn ('') />
</cffunction>

<cffunction name="beforeMetadataLoaded" output="false" access="public" returntype="void" hint="I run when the metadata is being set into this instance. You can override this and monkey with the metadata">
	<cfargument name="metadata" type="struct" required="true"/>
	<cfset  variables._metadata = arguments.metadata  />
</cffunction>

<cffunction name="loadMetadata" output="false" access="public" returntype="struct" hint="I return the configured metadata">
	<cfreturn variables._metadata />	
</cffunction>


</cfcomponent>
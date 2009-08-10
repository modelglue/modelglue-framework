<cfcomponent displayname="CollectionBeanMaker" output="false" hint="I make beans out of a GenericCollection.">

<cffunction name="init" output="false" hint="Constructor.">
	<cfreturn this />
</cffunction>

<cffunction name="MakeBean" output="false" returntype="any" hint="I return a bean CFC populated from the collection.">
	<cfargument name="collection" type="any" hint="Some form of ModelGlue MapCollection API." />
	<cfargument name="type" hint="I am either the CFC type to create or an instance of a CFC to populate." />
	<cfargument name="fields" hint="I am the [optional] list of fields to populate." />
	
	<cfset var instance = arguments.type  />
	<cfset var i = "" />
	
	<cfif isSimpleValue(arguments.type)>
		<cfset instance = createObject("component", arguments.type) />
		<cfif structKeyExists(instance, "init")>
			<cfset instance.init() />
		</cfif>
	</cfif>
	
	
	<cfif not structKeyExists(arguments, "fields")>
		<cfset arguments.fields = structKeyList(arguments.collection.getAll()) />
	</cfif>

	<cfloop list="#arguments.fields#" index="i">
		<cfif structKeyExists(instance, "Set#i#") and arguments.collection.Exists(i)>
			<cfinvoke component="#instance#" method="Set#i#">
				<cfinvokeargument name="#i#" value="#arguments.collection.getValue(i)#" />
			</cfinvoke>
		<cfelseif structKeyExists( instance, i)>
			<cfset instance[i] = arguments.collection.getValue(i) />
		</cfif>
	</cfloop>

	<cfreturn instance />
</cffunction>	

</cfcomponent>
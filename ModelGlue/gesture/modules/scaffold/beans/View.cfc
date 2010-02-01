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
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="##listEvent##">%spaceCap( Metadata.alias )%</a> / View %spaceCap( Metadata.alias )%</div>
<br />
<div>
<cfform class="edit"> 
<fieldset>
	<<cfloop collection="%Metadata.properties%" item="variables.thisProp">><<cfif listFindNoCase( Metadata.primaryKeyList, thisProp ) IS false AND Metadata.properties[thisProp].relationship IS false >>
			<div class="formfield">
				<label for="%Metadata.properties[thisProp].alias%"><b>%Metadata.properties[thisProp].label%:</b></label>
				<span class="input">##%Metadata.alias%Record.get%Metadata.properties[thisProp].alias%()##</span>
			</div>
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS false >>
			<cfset variables.sourceValue = "" />
			<cftry>
				<cfif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%")>
					<cfset variables.sourceValue = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%() />
				<cfelseif structKeyExists(%Metadata.alias%Record, "getParent%Metadata.properties[thisProp].alias%")>
					<cfset variables.sourceValue = %Metadata.alias%Record.getParent%Metadata.properties[thisProp].alias%() />
				</cfif>
				<cfcatch>
				</cfcatch>
			</cftry>
	
			<cfif isObject(variables.sourceValue)>
				<cfset variables.sourceValue = variables.sourceValue.get%Metadata.properties[thisProp].sourcecolumn%() />
			</cfif>
			<div class="formfield">
				<label for="%Metadata.properties[thisProp].alias%"><b>%Metadata.properties[thisProp].label%:</b></label>
				<span class="input">##variables.sourcevalue##</span>
			</div>
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS true >>
			<div class="formfield">
				<label for="%Metadata.properties[thisProp].alias%"><b>%Metadata.properties[thisProp].label%:</b></label>
				<cfif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%Struct")>
					<cfset variables.list = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Struct() />
					<cfloop collection="##variables.list##" item="variables.rel">
						<span class="input">##variables.list[variables.rel].get%Metadata.properties[thisProp].sourcecolumn%()##</span>
					</cfloop>
				<cfelseif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%Array")>
					<cfset variables.list = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Array() />
					<cfloop from="1" to="##arrayLen(variables.list)##" index="variables.idx">
						<span class="input">##variables.list[variables.idx].get%Metadata.properties[thisProp].sourcecolumn%()##</span>
					</cfloop>
				<cfelse>
					<cfset variables.list = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Iterator().getQuery() />
					<cfloop query="variables.list">
						<span class="input">##%Metadata.properties[thisProp].sourcecolumn%##</span>
					</cfloop>
				</cfif>
			</div>
		<</cfif>><</cfloop>>
</fieldset>
</cfform>
</div>
</cfoutput>
<</cfoutput>>
')>
</cffunction>
	
</cfcomponent>

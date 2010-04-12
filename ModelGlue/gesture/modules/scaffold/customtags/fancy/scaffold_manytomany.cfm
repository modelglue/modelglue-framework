<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfimport taglib="/modelglueextensions/cfuniform/tags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.objectName" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.childDescProperty" type="string" />
	<cfparam name="attributes.selectedList" type="string" default="" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
<</cfsilent>
<cfoutput>
<!--- 
hidden makes the field always defined.  if this was not here, and you deleted this whole field
from the control, you would wind up deleting all child records during a genericCommit...
--->
<input type="hidden" name="#attributes.label#|#attributes.name#" value="" />
<uform:field name="#attributes.label#|#attributes.name#" type="select" label="#attributes.label#" selectSize="3" inputClass="multiSelect">
<cfloop query="attributes.valueQuery">
	<uform:option display="#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#" 
		value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"
		isSelected="#listFindNoCase(attributes.selectedList, attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow])#" />
</cfloop>
</uform:field>
</cfoutput>

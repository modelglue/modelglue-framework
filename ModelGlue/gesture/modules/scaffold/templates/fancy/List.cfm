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


<<cfoutput>>
<cfsilent>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%Query,xe.delete,xe.edit,xe.list,xe.view,%Metadata.primaryKeyList%" )/>
	<cfset editEvent = myself & xe.edit />
	<cfset event.addCSSAssetFile( "menu.css" ) />
</cfsilent>
<cfoutput>
<div id="breadcrumb">%spaceCap( Metadata.alias )% / <a href="#editEvent#">Add New %spaceCap( Metadata.alias )%</a></div>
<br />
<mg:scaffold_list name="%Metadata.alias%" displayPropertyList="%getDisplayPropertyList(Metadata.orderedpropertylist,Metadata)%" primaryKeyList="%Metadata.primaryKeyList%" theList="#%Metadata.alias%Query#"
	viewEvent="#myself & xe.view#" editEvent="#editEvent#" deleteEvent="#myself & xe.delete#" />
</cfoutput>
<</cfoutput>>

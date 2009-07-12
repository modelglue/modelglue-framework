<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfoutput>
<h1>Sample Model-Glue Application</h1>

#viewCollection.getView("body")#

<p>
Model-Glue is copyright #datePart("yyyy", now())#, Joe Rinehart, http://clearsoftware.net.
</p>
</cfoutput>

<!---

<h2>Some Basics about Views</h2>

<em>
When in a view, you have two collections available to you.  
</em>

<p>
<strong>ViewState</strong> contains everything from FORM, URL, or any value set by using arguments.event.SetStateValue() in a controller.
</p>
<p>
<strong>ViewCollection</strong> contains contains rendered HTML from views that have rendered before the current view.
</p>
<p>CFDumps of the current values of both, and then the public interface of both follow.</p>
<cfdump var="#viewState.getAll()#" label="Everything in the viewstate">
<br />
<cfdump var="#viewCollection.getAll()#" label="Everything in the viewcollection">
<br />
<cfdump var="#viewState#" expand="false">
<br />
<cfdump var="#viewCollection#" expand="false">
--->

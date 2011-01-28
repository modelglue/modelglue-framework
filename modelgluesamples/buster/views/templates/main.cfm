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


<!---

This is a basic "wrapper" template for your application.

It expects you to run an event that includes a view named "body".
---><html>

<head>
	<link rel="stylesheet" type="text/css" href="css/stylesheet.css"></link>
</head>

<body>
<!---	<div id="banner">Model-Glue 3 ("Gesture")</div>--->
	
	<!--- Display the view named "body" --->
	<cfoutput>#viewCollection.getView("body")#</cfoutput>
<!---	
	<cfoutput>
	<div id="footer">
		<p>
			Model-Glue is &copy; #dateFormat(now(), "yyyy")# <a href="http://www.firemoss.com">Joe Rinehart</a>.  It's open source and free, released under the <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache License, Version 2.0</a>.
		</p>
		<p>
			Thanks to 
			<a href="http://www.coldfusionjedi.com/">Raymond Camden</a>,
			<a href="http://www.corfield.org">Sean Corfield</a>, 
			<a href="http://www.web-relevant.com/blogs/cfobjective">Jared Rypka-Hauer</a>,
			<a href="http://www.briankotek.com/blog/">Brian Kotek</a>,
			<a href="http://www.compoundtheory.com">Mark Mandel</a>,
			<a href="http://en.wikipedia.org/wiki/Ayn_Rand">Ayn Rand</a>,
			<a href="http://www.d-ross.org">Dave Ross</a>,
			<a href="http://cdscott.blogspot.com/">Chris Scott</a>,
			<a href="http://www.boyzoid.com">Scott Stroz</a>,
			<a href="http://www.firemoss.com">Firemoss</a>,
			<a href="http://www.alagad.com">Alagad</a>,
			<a href="http://www.aboutweb.com">AboutWeb</a>,
			and most of all
			Dale and Ava Rinehart.
		</p>
	</div>
	</cfoutput>
--->
</body>

</html>

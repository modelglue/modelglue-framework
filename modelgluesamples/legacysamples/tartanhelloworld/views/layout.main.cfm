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


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>
	<title>HelloWorld Model-Glue + Tartan Test</title>
</head>

<body>
<table align="center" border="1">
	<tr><td><strong>Your Greeting:</strong></td></tr>
	<tr><td align="center"><cfoutput>#viewstate.getValue("greeting")#</cfoutput></td></tr>
	<tr><th align="center">Also available in:</th></tr>
	<tr><td align="center"><a href="index.cfm?lang=English">English</a></td></tr>
	<tr><td align="center"><a href="index.cfm?lang=French">French</a></td></tr>
	<tr><td align="center"><a href="index.cfm?lang=German">German</a></td></tr>
	<tr><td align="center"><a href="index.cfm?lang=Spanish">Spanish</a></td></tr>
	<tr><td align="center"><a href="index.cfm?lang=Martian">Martian</a></td></tr>
</table>
</body>

</html>
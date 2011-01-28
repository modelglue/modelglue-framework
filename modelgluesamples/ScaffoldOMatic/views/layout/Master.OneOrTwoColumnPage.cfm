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


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<cfsilent>
	<cfset hasSecondaryContent = viewCollection.exists("Secondary") />
	<cfset HeaderContent = viewCollection.getView("Header") />
	<cfset MenuContent = viewCollection.getView("Menu") />
	<cfset MessageContent = viewCollection.getView("Message") />
	<cfset PrimaryContent = viewCollection.getView("Body") />
	<cfset SecondaryContent = viewCollection.getView("Secondary") />
	<cfset FooterContent = viewCollection.getView("Footer") />
</cfsilent>
<cfoutput>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta name="generator" content="HTML Tidy for Linux/x86 (vers 1 September 2005), see www.w3.org" />
	<meta http-equiv="Content-Type" content="text/html; charset=us-ascii" />
	<title>ScaffoldOMatic</title>
	<link rel="stylesheet" type="text/css" media="all" href="www/css/pagestructure.css" />
	<link rel="stylesheet" type="text/css" media="all" href="www/css/menu.css" />
</head>

<body>

	<div id="container"><!-- container -->
		#HeaderContent#
		#MenuContent#
		#MessageContent#
		
		<cfif hasSecondaryContent IS true>
		<div id="left"><!-- left division -->
			#SecondaryContent#
		</div><!-- end left division -->
		</cfif>
		<div id="main" class="<cfif hasSecondaryContent IS false>oneColumnMain</cfif>">
			#PrimaryContent#
		</div>

		<div id="footer"><!-- footer -->
			#FooterContent#
		</div><!-- end footer -->
	</div><!-- end container -->
</body>
</html>
</cfoutput>

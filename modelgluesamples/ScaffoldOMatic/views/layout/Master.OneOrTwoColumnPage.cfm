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
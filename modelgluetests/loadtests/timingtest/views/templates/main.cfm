<!---

This is a basic "wrapper" template for your application.

It expects you to run an event that includes a view named "body".
---><html>

<head>
	<link rel="stylesheet" type="text/css" href="css/stylesheet.css"></link>
</head>

<body>
	
	<!--- Display the view named "body" --->
	<cfoutput>#viewCollection.getView("body")#</cfoutput>
	
</body>

</html>
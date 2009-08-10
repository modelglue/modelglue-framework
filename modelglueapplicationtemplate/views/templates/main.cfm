<!---

This is a basic "wrapper" template for your application.

It expects you to run an event that includes a view named "body".
---><html>

<head>
	<link rel="stylesheet" type="text/css" href="css/stylesheet.css"></link>
</head>

<body>
	<div id="banner">Model-Glue 3 ("Gesture")</div>
	
	<!--- Display the view named "body" --->
	<cfoutput>#viewCollection.getView("body")#</cfoutput>
	
	<cfoutput>
	<div id="footer">
		<h2>Model-Glue 3 is headed up by  <a href="http://www.nodans.com">Dan Wilson</a></h2>
		<p>
			<ul>
				<li>Home Page: <a href="http://www.model-glue.com">http://www.model-glue.com</a></li>
				<li>Documentation: <a href="http://docs.model-glue.com">http://docs.model-glue.com</a></li>
				<li>Bug Tracker: <a href="http://bugs.model-glue.com">http://bugs.model-glue.com</a></li>
				<li>Blog: <a href="http://www.model-glue.com/blog">http://www.model-glue.com/blog</a></li>
			</ul>
		</p>
		
		<h2>Model-Glue 3 is Open Source</h2>
		<p>It's open source and free, released under the <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache License, Version 2.0</a></p>			
		
		<h2>Model-Glue 3 is copyrighted</h2>
		<p>&copy; #dateFormat(now(), "yyyy")# <a href="http://www.firemoss.com">Joe Rinehart</a> and <a href="http://www.nodans.com">Dan Wilson</a></p>
		
		<h2>Model-Glue 3 Contributors (alphabetically)</h2>
		<p>
			<ul>
				<li><a href="http://blog.simb.net/">Simeon Bateman</a>
				<li><a href="http://pbell.com">Peter Bell</a></li>
				<li><a href="http://chris.m0nk3y.net/">Chris Blackwell</a></li>
				<li><a href="http://www.coldfusionjedi.com/">Ray Camden</a></li>
				<li><a href="http://www.alagad.com/go/blog?createdBy=jchastain">Jeff Chastain</a></li>
				<li><a href="http://www.markdrew.co.uk/">Mark Drew</a></li>
				<li><a href="http://mxunit.org/">Marc Esher</a></li>
				<li><a href="http://blog.coldfusionpowered.com/">David Henry</a></li>
				<li><a href="http://alagad.com">Doug Hughes</a></li>
				<li><a href="http://www.compoundtheory.com/">Mark Mandel</a></li>
				<li><a href="http://fancybread.com/">Paul Marcotte</a></li>
				<li><a href="http://www.codfusion.com/blog/">John Mason</a></li>
				<li><a href="http://cfgrok.com">Ezra Parker</a></li>
				<li><a href="http://www.cfcode.net/blog/">Chris Peterson</a></li>
				<li><a href="http://thecrumb.com">Jim Priest</a></li>
				<li><a href="http://firemoss.com">Joe Rinehart</a></li>
				<li><a href="http://www.web-relevant.com/blogs/cfobjective/index.cfm">Jared Rypka-Hauer</a></li>
				<li><a href="http://buckyschwarz.net/site/blog/">Bucky Schwarz</a></li>
				<li><a href="http://www.silverwareconsulting.com">Bob Silverberg</a></li>
				<li><a href="http://dan.skaggsfamily.ws/">Dan Skaggs</a></li>
				<li><a href="http://www.boyzoid.com/blog/">Scott Stroz</a></li>
			</ul>
		</p>
		
		<h2>Model-Glue Hall of Fame</h2> 
		<p>
			<a href="http://www.coldfusionjedi.com/">Raymond Camden</a>,
			<a href="http://www.corfield.org">Sean Corfield</a>, 
			<a href="http://www.web-relevant.com/blogs/cfobjective">Jared Rypka-Hauer</a>,
			<a href="http://www.briankotek.com/blog/">Brian Kotek</a>,
			<a href="http://www.compoundtheory.com">Mark Mandel</a>,
			<a href="http://www.d-ross.org">Dave Ross</a>,
			<a href="http://cdscott.blogspot.com/">Chris Scott</a>,
			<a href="http://www.boyzoid.com">Scott Stroz</a>,
			<a href="http://www.nodans.com">Dan Wilson</a>,
			<a href="http://www.firemoss.com">Firemoss</a>,
			<a href="http://www.alagad.com">Alagad</a>,
			<a href="http://www.aboutweb.com">AboutWeb</a>,
			<a href="http://www.datacurl.com">DataCurl</a>,			
		</p>
	</div>

	</cfoutput>
</body>

</html>
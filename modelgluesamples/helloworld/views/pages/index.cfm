<h2>Hi There, I'm a simple Model-Glue application.</h3>

<p>
There's not much to me.  I'm just an example of how to build an event-handler (page) that uses
a default template for its look and feel.
</p>

<h3>Event Handler?</h3>

<p>
When you use Model-Glue, each of your site's "pages" is defined by an &lt;event-handler>
tag in its ModelGlue.xml file (which can be broken up, moved, etc. to your heart's content).
</p>

<p>Here's mine:</p>

<pre>
&lt;event-handler name="page.index">
	&lt;broadcasts />
	&lt;views>
		&lt;include name="body" template="pages/index.cfm" />
	&lt;/views>
	&lt;results>
		&lt;result do="template.main" />
	&lt;/results>
&lt;/event-handler>
</pre>

<h3>Broadcast?</h3>

<p>
To get or store data, any &lt;event-handler> can "broadcast a message" stating that it needs something, 
like a database query. I'm a simple example, though, and I don't do that.  See [ADD THIS] for 
a basic example of it.
</p>

<h3>Views?  Include?</h3>

<p>
To render output, any &lt;event-handler> can use an &lt;include> tag to include a .CFM template.
It's just like &lt;cfinclude, except that each include tag must have a "name" attribute.  Any included
.CFM template can display the content of a previous by looking it up by name.  This code from 
/template/main.cfm shows this in action see this in action:
</p>

<pre>
&lt;!--- Display the view named "body" --->
&lt;cfoutput>#viewCollection.getView("body")#&lt;/cfoutput>
</pre>

<h3>Results?</h3>

<p>
A &lt;result> tag tells Model-Glue to execute another event-handler.  If the result tag
doesn't have a "name" attribute, it'll automatically run the event-handler.  Results are a key
part of Model-Glue, and are explained in the [ADD THIS - form validation example].
</p>
<p>
I use a &lt;result> tag pointing to the private "template.main" event.  Its purpose to to 
provide a sitewide template, with a standard header and footer.
</p>

<h3>Putting it all together.</h3>

When I run, I don't do any broadcasts.  I include the "pages/index.cfm" view, which contains
the content you're reading now.  When that's done, a result without a name instructs Model-Glue
to execute the "template.main" event.  It includes the "templates/main.cfm" view, which outputs
a header and footer with the contents of the already rendered "pages/index.cfm" view in the middle.

Model-Glue prints out the last view rendered, so it's the result of including "templates/main.cfm"
that gets sent to the browser.


 


 
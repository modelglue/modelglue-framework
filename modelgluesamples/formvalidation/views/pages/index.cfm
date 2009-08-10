<cfform action="#event.linkTo("form.validate")#">

<fieldset>
	<legend>Sample Form</legend>
	
	<cfinput type="text" name="name" />
	
	<input type="submit" value="Submit" />
	<cfoutput>#helpers.modelglue.showErrors(event.getValue("validationErrors"), "name")#</cfoutput>
</fieldset>

</cfform>

<h2>Simple Form Validation</h2>

<p>
This example shows how to validate a form and use the ModelGlue.Util.ValidationErrorCollection 
object to show validation results.
</p>

<h3>Event Handlers</h3>
<p>
The above form form is submitted to an "action event" that handles the form submission named "form.validate":
</p>

<pre>
&lt;cfform action="#event.linkTo("form.validate")#">
</pre>

<p>
The "form.validate" event does a few things.  Here's its XML:
</p>

<pre>
&lt;event-handler name="form.validate">
	&lt;broadcasts>
		&lt;message name="needFormValidation" />
	&lt;/broadcasts>
	&lt;results>
			&lt;result name="validationErrors" do="page.index" />
			&lt;result name="success" do="form.submitted" redirect="true" />
	&lt;/results>
&lt;/event-handler>	
</pre>

<p>When requested, the form.validate event first dispatches a message, "formValidationNeeded".  Because it subscribes
with a &lt;message-listener/&gt; tag, Controller.cfc invokes its validateForm() function.</p>

<h3>Listener Functions, ValidationErrorCollection, and Results</h3>

<p>This collects errors in a utility CFC called ValidationErrorCollection that's capable of storing an array of errors
for any number of fields.  The function checks to make sure the user filled out the "name" field:  if they didnt, it adds an error
related to the "name" field to the error collection.</p>
</p>
<p>Once it's done validating, validateForm() adds a "result" to the event, named either "validationErrors" or "success,"
based on whether or not there are any validation errors.</p>
<p>These results correspond to result tags in the &lt;event-handler&gt; XML:  if "success" is added, the user is redirected to 
the form.submitted event.  If "validationErrors" is added, Model-Glue runs the page.index event after it's done
running form.validate, without doing a redirect.</p>
<p>If form validation errors exist, the validation error collection is added to the event, allowing views to display the errors.</p>

<pre>
&lt;cffunction name="valdiateForm" output="false">
	&lt;cfargument name="event" />
	
	&lt;cfset var validation = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />

	&lt;cfif not len(trim(arguments.event.getValue("name")))>
		&lt;cfset validation.addError("name", "Please enter your name.") />
	&lt;/cfif>
	
	&lt;cfif validation.hasErrors()>
		&lt;cfset arguments.event.setValue("validationErrors", validation) />
		&lt;cfset arguments.event.addResult("validationErrors") />
	&lt;cfelse>
		&lt;cfset arguments.event.addResult("success") />
	&lt;/cfif>
&lt;/cffunction>
</pre> 

<h3>Displaying Errors</h3>

<p>If the user doesn't submit their name, we need to show them the error message.  While we could use the ValidationErrorCollection added to the event manually,
it's easier to use a helper function that's included with Model-Glue.</p>

<p>To show the errors under the input, we just ask the helper function to show errors from the collection associated with the "name" field:</p>

<pre>
&lt;cfoutput>#helpers.modelglue.showErrors(event.getValue("validationErrors"), "name")#&lt;/cfoutput>
</pre>


<h1>Rich Widgets</h1>

<h3>Plain old HTML</h3>

<p>Submit this form, and the page will reload, translating your input into pig latin.</p>

<cfform action="#event.linkTo("page.index")#" id="html">
	<cfinput type="text" name="phrase" required="true" message="Please enter a phrase." />
	<input type="submit" value="Go" />
</cfform>

<cfoutput>
#viewCollection.getView("translation")#
</cfoutput>

<h3>Simple &lt;div&gt; replacement.</h3>

<p>Using Prototype (jQuery would work, too) to update a div - same event handler, different request format!</p>

<form id="ajax" onsubmit="new Ajax.Updater('ajax_result', 'index.cfm?requestFormat=htmlPartial&phrase=' + $('ajax_phrase').value);return false;">
	<input type="text" id="ajax_phrase" />
	<input type="submit" value="Go" />
</form>

<div id="ajax_result">
	Here you go:
</div>

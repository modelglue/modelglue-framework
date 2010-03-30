component persistent="true" table="Lang"
{
	property name="LanguageId" fieldtype="id" generator="increment" type="numeric";
	property name="LanguageName" notnull="true" default="";
	property name="Countries" fieldtype="many-to-many" cfc="Country" type="array" linktable="CountryLanguage" inverse="true" singularname="Country" fkcolumn="LanguageId";
	
	public Language function init() {
		if (isNull(variables.Countries)) {
			variables.Countries = [];
		}
		return this;
	}
	
	public void function addCountry(required Country Country) 
		hint="set both sides of the bi-directional relationship" {
		arguments.Country.addLanguage(variables.LanguageName,this);
		/*
		// set this side
		if (not hasCountry(arguments.Country)) {
			arrayAppend(variables.Countries,arguments.Country);
		}
		// set the other side
		if (not arguments.Country.hasLanguage(variables.LanguageName)) {
			arguments.Country.addLanguage(variables.LanguageName,this);
		}
		*/
	}

	public void function removeCountry(required Country Country) 
		hint="set both sides of the bi-directional relationship" {
		arguments.Country.removeLanguage(variables.LanguageName);
		/*
		// set this side
		var index = arrayFind(variables.Countries,arguments.Country);
		if (index gt 0) {
			arrayDeleteAt(variables.Countries,index);
		}
		// set the other side
		if (arguments.Country.hasLanguage(variables.LanguageName)) {
			arguments.Country.removeLanguage(variables.LanguageName);
		}
		*/
	}

}

/*

That's a great idea, Barney.

In the cfc that is simply delegating you'd still have to check whether the action needs to be done or not, using the appropriate has() method, right?  I just tried a quick test where I simply delegated without a check and I ended up with an infinite loop.

*/

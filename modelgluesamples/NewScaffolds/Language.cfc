component persistent="true" table="Lang"
{
	property name="LanguageId" fieldtype="id" generator="increment" type="numeric";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country" type="array" linktable="CountryLanguage" inverse="true" singularname="Country" fkcolumn="LanguageId";
	
	public void function removeCountry(object) hint="set both sides of the bi-directional relationship" {
		var Languages = arguments.object.getLanguages();
		if (isStruct(Languages)) {
			structDelete(Languages,variables.LanguageName);
		}
		if (isArray(variables.Countries)) {
			var index = arrayFind(variables.Countries,arguments.object);
			if (index gt 0) {
				arrayDeleteAt(variables.Countries,index);
			}
		}
	}

	public void function addCountry(object) hint="set both sides of the bi-directional relationship" {
		var Languages = arguments.object.getLanguages();
		if (not isStruct(Languages)) {
			Languages = {};
		}
		Languages[variables.LanguageName] = this;
		arrayAppend(variables.Countries,arguments.object);
	}
}

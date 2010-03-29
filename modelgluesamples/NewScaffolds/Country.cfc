component persistent="true" orderedPropertyList="CountryCode,CountryName,SortSequence,Provinces,Languages"
{
	property name="CountryId" fieldtype="id" generator="increment" type="numeric";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Provinces" fieldtype="one-to-many" cfc="Province" type="array" singularname="Province" fkcolumn="CountryId" inverse="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language" type="struct" structkeycolumn="LanguageName" structkeytype="string" linktable="CountryLanguage" singularname="Language" fkcolumn="CountryId";
	
	public Country function init() {
		if (isNull(variables.Languages)) {
			variables.Languages = {};
		}
		return this;
	}
	
	public void function addLanguage(required string key,required Language Language) 
		hint="set both sides of the bi-directional relationship" {
		// set this side
		variables.Languages[arguments.key] = arguments.Language;
		// set the other side
		if (not arguments.Language.hasCountry(this)) {
			arguments.Language.addCountry(this);
		}
	}

	public void function removeLanguage(required string key) 
		hint="set both sides of the bi-directional relationship" {
		// set the other side
		var Language = (structKeyExists(variables.Languages,arguments.key) ? variables.Languages[arguments.key] : "");
		if (isObject(Language) and Language.hasCountry(this)) {
			Language.removeCountry(this);
		}
		// set this side
		structDelete(variables.Languages,arguments.key);
	}

}

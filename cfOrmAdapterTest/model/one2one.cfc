component persistent="true" output="false"
{
	property name="mainId" fieldtype="id" generator="foreign" params="{property='mainObject'}" ormtype="integer";
	property name="type_binary" type="binary";
	property name="type_boolean" type="boolean";
	property name="type_date" type="date";
	//property name="type_guid" type="guid";
	property name="type_numeric" type="numeric";
	property name="type_string" type="string";
	//property name="type_uuid" type="uuid";

	property name="mainObject" fieldtype="one-to-one" cfc="MainObject" constrained="true";

}

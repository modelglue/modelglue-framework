<?xml version="1.0" encoding="UTF-8"?>
<modelglue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:noNamespaceSchemaLocation="http://www.model-glue.com/schema/gesture/ModelGlue.xsd">

	<event-types>
		<event-type name="templatedPage">
			<after>
				<views>
					<view name="menu" template="Layout.Menu.cfm" />
					<view name="template" template="dspDisplayTemplate.cfm" />
				</views>
			</after>
		</event-type>
	</event-types>

	<event-handlers>
		
		<scaffold object="Country" propertylist="CountryCode,CountryName,SortSequence,Languages,Provinces" event-type="templatedPage" />
		
		<scaffold object="Language" propertylist="LanguageName,Countries" event-type="templatedPage" />
		
		<scaffold object="Province" event-type="templatedPage" />
		
	</event-handlers>

</modelglue>

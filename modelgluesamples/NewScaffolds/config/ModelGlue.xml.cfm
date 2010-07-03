<?xml version="1.0" encoding="UTF-8"?>
<modelglue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:noNamespaceSchemaLocation="http://www.model-glue.com/schema/gesture/ModelGlue-strict.xsd">
	<controllers>
		<controller id="Controller" type="modelgluesamples.NewScaffolds.controller.Controller">
			<message-listener message="onRequestStart" />
		</controller>
	</controllers>

	<event-types>
		<event-type name="templatedPage">
			<after>
				<results>
					<result do="display.template" />
				</results>
			</after>
		</event-type>
	</event-types>

	<event-handlers>
		<event-handler name="display.template">
			<broadcasts />
			<results />
			<views>
				<view name="template" template="dspDisplayTemplate.cfm" />
			</views>
		</event-handler>
		
		<scaffold object="Country" propertylist="CountryCode,CountryName,SortSequence,Languages,Provinces" event-type="templatedPage" />
		
		<scaffold object="Language" propertylist="LanguageName,Countries" event-type="templatedPage" />
		
		<scaffold object="Province" event-type="templatedPage" />
		
	</event-handlers>
</modelglue>


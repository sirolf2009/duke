package com.sirolf2009.duke.core.allocation

import com.esotericsoftware.kryo.io.Input
import com.esotericsoftware.kryo.io.Output
import com.sirolf2009.duke.core.ID
import java.io.File
import java.lang.reflect.Method
import java.util.HashMap
import java.util.Map
import org.reflections.Reflections
import org.reflections.scanners.FieldAnnotationsScanner
import com.google.common.base.Function

class DataFileAllocationStream implements AutoCloseable {

	String location;
	Class<?> clazz;
	Function<Object, Object> IDProducer;
	Map<Object, DataFileAllocationStreamCache> cache;

	new(String location, Class<?> clazz) {
		this.location = location;
		this.clazz = clazz;
		cache = new HashMap<Object, DataFileAllocationStreamCache>();
		IDProducer = getIDProducer();
		new File(location).mkdirs();
	}

	def Output getOutputForObject(Object object) {
		return getFromObject(object).getOutput();
	}

	def Input getInputForObject(Object object) {
		return getFromObject(object).getInput();
	}

	def Output getOutput(Object ID) {
		return get(ID).getOutput();
	}

	def Input getInput(Object ID) {
		return get(ID).getInput();
	}

	def File getFileForObject(Object object) {
		return getFromObject(object).getFile();
	}

	def File getFile(Object ID) {
		return get(ID).getFile();
	}

	def DataFileAllocationStreamCache getFromObject(Object object) {
		return get(getIDForObject(object));
	}

	def DataFileAllocationStreamCache get(Object ID) {
		if(!cache.keySet().contains(ID)) {
			cache.put(ID, new DataFileAllocationStreamCache(location+"/"+ID, clazz));
		}
		return cache.get(ID);
	}

	def Object getIDForObject(Object object) {
		return IDProducer.apply(object);
	}

	override void close() throws Exception {
		cache.values().forEach[close];
	}

	def Function<Object, Object> getIDProducer() {
		val IDField = new Reflections(clazz, new FieldAnnotationsScanner()).getFieldsAnnotatedWith(ID).get(0)//.orElseThrow[new RuntimeException("No ID field found for class "+clazz)]
		if(IDField.isAccessible()) {
			return [return IDField.get]
		} else {
			val prefix = if(IDField.getType().equals(Boolean)) "is" else "get";
			val name = IDField.getName();
			val capitalizedName = name.substring(0, 1).toUpperCase() + name.substring(1);
			val Method method = clazz.getMethod(prefix+capitalizedName);
			return [method.invoke(it)];
		}
	}
}
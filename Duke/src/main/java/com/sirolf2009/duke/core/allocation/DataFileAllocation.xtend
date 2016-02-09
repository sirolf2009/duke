package com.sirolf2009.duke.core.allocation

import java.util.HashMap
import java.util.Map

class DataFileAllocation implements AutoCloseable {

	private String location;
	private Map<Class<?>, DataFileAllocationStream> cache;

	new(String location) {
		this.location = location
		cache = new HashMap<Class<?>, DataFileAllocationStream>()
	}

	def getOutput(Object ID, Class<?> clazz) {
		return get(clazz).getOutput(ID);
	}

	def getInput(Object ID, Class<?> clazz) {
		return get(clazz).getInput(ID);
	}

	def getOutput(Object object) {
		return get(object.getClass()).getOutputForObject(object);
	}

	def getInput(Object object) {
		return get(object.getClass()).getInputForObject(object);
	}

	def getFile(Object ID, Class<?> clazz) {
		return get(clazz).getFile(ID);
	}

	def getFile(Object object) {
		return get(object.getClass()).getFileForObject(object);
	}

	def get(Class<?> clazz) {
		if(!cache.keySet().contains(clazz)) {
			cache.put(clazz, new DataFileAllocationStream(location+"/"+clazz.getSimpleName(), clazz));
		}
		return cache.get(clazz);
	}

	override void close() throws Exception {
		cache.values().forEach[close];
	}
}

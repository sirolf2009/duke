package com.sirolf2009.duke.core

import java.util.Arrays
import java.util.stream.Stream
import org.reflections.Reflections

class Register {

	def register(Stream<Class<?>> classes) {
	}
	
	def getRegisterable(String packagePrefix) {
		val entities = new Reflections(packagePrefix).getTypesAnnotatedWith(DBEntity)
		return entities.stream().flatMap[this.getRegisterable(it)]
	}

	def Stream<Class<?>> getRegisterable(Class<?> clazz) {
		if(Object.isAssignableFrom(clazz)) {
			return Arrays.stream(clazz.getDeclaredFields()).flatMap[getRegisterable(it.type)]
		}
		return newArrayList().stream
	}
	
}
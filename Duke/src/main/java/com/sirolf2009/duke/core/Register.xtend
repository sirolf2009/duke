package com.sirolf2009.duke.core

import java.util.List
import org.reflections.Reflections

class Register {

	def register(List<Class<?>> classes) {
	}
	
	def getRegisterable(String packagePrefix) {
		val entities = new Reflections(packagePrefix).getTypesAnnotatedWith(DBEntity)
		return entities.map[this.getRegisterable(it)].flatten
	}

	def List<Class<?>> getRegisterable(Class<?> clazz) {
		if(Object.isAssignableFrom(clazz)) {
			return clazz.getDeclaredFields().map[getRegisterable(it.type)].flatten.toList
		}
		return newArrayList()
	}
	
}
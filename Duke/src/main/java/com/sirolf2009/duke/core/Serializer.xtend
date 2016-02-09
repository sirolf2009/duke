package com.sirolf2009.duke.core

import java.io.InputStream
import java.io.OutputStream
import java.lang.reflect.Type

interface Serializer {
	
	def void writeObject(OutputStream out, Object object)
	def Object readObject(InputStream in, Type type)
	
}
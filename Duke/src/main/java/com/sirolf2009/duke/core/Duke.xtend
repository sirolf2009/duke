package com.sirolf2009.duke.core

import com.sirolf2009.duke.core.allocation.DataFileAllocation
import java.util.Arrays
import java.util.stream.Stream
import org.reflections.Reflections
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
public class Duke implements AutoCloseable {

	String databaseLocation;
	DataFileAllocation fileAllocation;
//	List<Class<?>> registeredClasses;
	String packagePrefix;
	Connection connection;

	new(String databaseLocation, String packagePrefix) {
		this.databaseLocation = databaseLocation
		fileAllocation = new DataFileAllocation(databaseLocation)
//		registeredClasses = getRegisterable(packagePrefix).collect(Collectors.toList()) as List<Class<?>>
		connection = Connection.getInstance(this)
	}

	def void save(Object object) {
		create(object)
	}

	def create(Object object) {
		connection.execute[
			val out = fileAllocation.getOutput(object);
			writeObject(out, object);
			out.close();
			return true;
		];
	}

	def <T> T read(Object ID, Class<T> type) {
		if(exists(ID, type)) {
			return connection.execute[
				val input = fileAllocation.getInput(ID, type);
				val object = readObject(input, type);
				input.close();
				return object;
			]
		}
		return null;
	}

	def update(Object object) {
		create(object);
	}

	def deleteObject(Object ID, Class<?> clazz) {
		fileAllocation.getFile(ID, clazz).delete();
	}

	def delete(Object object) {
		fileAllocation.getFile(object).delete();
	}

	def exists(Object object) {
		return fileAllocation.getFile(object).exists();
	}

	def exists(Object ID, Class<?> clazz) {
		return fileAllocation.getFile(ID, clazz).exists();
	}

	override void close() throws Exception {
		fileAllocation.close()
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

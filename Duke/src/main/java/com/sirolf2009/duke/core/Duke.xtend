package com.sirolf2009.duke.core

import com.sirolf2009.duke.core.allocation.DataFileAllocation
import com.sirolf2009.duke.core.exception.CreationException
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.reflections.Reflections

@Accessors
public class Duke implements AutoCloseable {

	String databaseLocation;
	DataFileAllocation fileAllocation;
	String packagePrefix;
	Connection connection;

	new(String databaseLocation, String packagePrefix) {
		this.databaseLocation = databaseLocation
		fileAllocation = new DataFileAllocation(databaseLocation)
		connection = Connection.getInstance(this)
	}

	def void save(Object object) {
		create(object)
	}

	def create(Object object) {
		val error = connection.execute[
			try {
			val out = fileAllocation.getOutput(object)
			writeObject(out, object)
			out.close()
			return null
			} catch(Exception e) {
				return e
			}
		]
		if(error != null) {
			throw new CreationException("Failed to create object", error)
		}
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
		return entities.map[this.getRegisterable(it)].flatten.toList
	}

	def List<Class<?>> getRegisterable(Class<?> clazz) {
		if(Object.isAssignableFrom(clazz)) {
			return clazz.getDeclaredFields().map[getRegisterable(it.type)].flatten.toList
		}
		return newArrayList()
	}

}

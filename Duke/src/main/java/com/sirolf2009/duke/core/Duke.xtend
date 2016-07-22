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
	
	def void saveAll(Object[] object) {
		object.forEach[create]
	}

	def create(Object object) {
		val error = connection.execute [
			try {
				val out = fileAllocation.getOutput(object)
				writeObject(out, object)
				out.close()
				return true
			} catch(Exception e) {
				return e
			}
		]
		if(error != null && error instanceof Throwable) {
			throw new CreationException("Failed to create object", error as Throwable)
		}
	}

	def <T> T read(Object ID, Class<T> type) {
		if(exists(ID, type)) {
			return connection.execute [
				val input = fileAllocation.getInput(ID, type);
				val object = readObject(input, type);
				input.close();
				return object;
			]
		}
		return null;
	}

	def <T> List<T> all(Class<T> type) {
		return connection.execute [conn|
			val files = fileAllocation.files
			return files.map[fileAllocation.getInput(name, type)].map[
				val object = conn.readObject(it, type)
				it.close
				return object
			].toList
		]
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

package com.sirolf2009.duke.core.allocation

import com.esotericsoftware.kryo.io.Input
import com.esotericsoftware.kryo.io.Output
import com.esotericsoftware.kryo.io.UnsafeInput
import com.esotericsoftware.kryo.io.UnsafeOutput
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class DataFileAllocationStreamCache implements AutoCloseable {
	
	Input input;
	Output output;
	String location;
	Class<?> clazz;

	new(String location, Class<?> clazz) {
		this.location = location;
		this.clazz = clazz;
	}

	def getOutput() {
		try {
			close()
			getFile().parentFile.mkdirs()
			getFile().createNewFile()
			output = new UnsafeOutput(new FileOutputStream(new File(location)))
			return output;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	def getInput() {
		try {
			close();
			getFile().parentFile.mkdirs()
			getFile().createNewFile();
			input = new UnsafeInput(new FileInputStream(new File(location)));
			return input;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	def getFile() {
		return new File(location);
	}

	def closeInput() {
		if(input != null) {
			input.close();
		}
		input = null;
	}

	def closeOutput() {
		if(output != null) {
			output.close();
		}
		output = null;
	}

	override void close() throws Exception {
		closeOutput();
		closeInput();
	}

}
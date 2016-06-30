package com.sirolf2009.duke.core.exception;

@SuppressWarnings("all")
public class MissingIDException extends Exception {
  public MissingIDException(final Class<?> clazz) {
    super((clazz + " has no ID field"));
  }
}

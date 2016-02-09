![](http://i.imgur.com/w1EY0s8.png)

Duke is a database built using kryo. In short, it recursively registers POJO's by using annotations and saves them to files.

It's built using Eclipse XTend, which is translated into java 5 code. So even if you don't use xtend, you can still use this library

### Example
```java
import com.sirolf2009.duke.core.ID
import com.sirolf2009.duke.core.DBEntity

@DBEntity //This annotation means that this class can be stored
public class PersonBean {

  @ID //The unique identifier to use
  private String name;
  private Job job; //This class doesn't need the @ID or @DBEntity annotations, it will be registered because it is in the person class
  
  protected PersonBean() {} //We need a non args constructor for when the object is recreated from the database
  
  public PersonBean(String name, Job job) {
    this.name = name;
    this.job = job;
  }
  
  /*
   * We need getters and setters, because the fields are private
   */
  
  public String getName() {
    return name;
  }
  public void setName(String name) {
    this.name = name;
  }
  public Job getJob() {
    return job;
  }
  public void setJob(Job job) {
    this.job = job;
  }
```
Save and read it like so
```java
Person person = new Person("sirolf2009", new Job())
Duke duke = new Duke("src/main/resources/database", "com.awesomename.awesomeproduct"); //First parameter is the location of the database (where to store files), Second is your package, Duke will scan this packages and all subpackages for DBEntities
duke.save(person);
Person samePerson = duke.read("sirolf2009", Person.class);
```

# CoreData

Core Data is an Apple Local object graph persistence framework. Basically it’s a way of storing the data locally and retrieve it later for use.
Data stays locally in a device, so it’s not a solution for sharing data with other users and it’s  not a solution for syncing data across multiple devices although some of that can be done when you combine core data with cloud kit.

Why we use Core Data ?
Well assuming you need to store data in your app some benefits of using core data include:

Benefits:
+ First Party Apple Framework. Work well with apple’s other frameworks and APIs.
+ Apple is going to make sure it doesn’t get left behind, that any new technology it releases will work with it.
+ No needs to worry about managing 3rd party libraries and SDKs

Drawbacks:
+ Not for remote (online) data storage.
+ There is a learning curve when getting into Core Data.
+ Think “Object Graph Persistence”

Like in Traditional Database we explicitly insert, create, delete and update data from the database now even though under the hood core data is using an SQLite database you don’t have to explicitly tell core data to insert, create, delete and update. we just create and work with objects in your app like normal and behind the scenes core data will manage the data persistence for you.

For example we have two classes:

![image](https://user-images.githubusercontent.com/63160825/220068567-f87a1c37-2c11-476e-b454-a6ac1957950f.png)

Person and Family. The person class contains some properties and the family class has a property storing the person objects for that family. You can create a family object in several person objects and then you relate those person object to the family object now you want to store it in Core Data. 
The most important component of Core data is CORE DATA PERSISTENT CONTAINER

Core Data Persistent Container, you can think as a representation of the core data store or database , however your objects don’t interact with the persistent container directly there is a layer on the top of the Persistent called the MANAGED OBJECT CONTEXT. Think it as sort of a Data Manager Layer your objects will go through the managed object context to be stored or retrieved from the persistent store.

![image](https://user-images.githubusercontent.com/63160825/220068803-6a991f56-2745-4a9e-bfd4-a0437ab91783.png)

Now these objects and memory along with how they relate to each other is called an OBJECT GRAPH. When you store the objects into the core data all of the data in the properties along with the relationships are preserved in other words the object graph. When you retrieve them from core data back into memory you can get them back in the same state they were in before. That is why they call CORE DATA AN OBJECT GRAPH PERSISTENCE FRAMEWORK.

How Core Data works:

Like in Json File we decode them into useable objects in our app, the process of changing the data into a different format and back is known as encoding and decoding or serialising or deserialising.
While core data do the same thing here it serialise the object into a format that can be stored in the underlying SQLite database and then it will deserialise it back into the objects of memory the code or functionality to do that serialising and deserialising is with a class called NS-MANAGED OBJECT.

If you want your class to be able to captured in core data you need to subclass ns-managed  object that gives object of your custom class the ability to be stored with core data. So now your objects can be serialise and stored with core data. When you want to bring that object back from core data how does it know what format to deserialise that data back into in other words if you need your person back how does it know about your person class and what properties your person class contains.
 We have visual editor when you have to define class in core data model, they call the class an entity in the properties of your class called attributes of that entity then after you define the entity and its attributes in other words your class and its properties, we generate the classes from the core data model file they will assigned to the NS-MANAGED, so that core data can serialise and deserialise it. Then we use that generator to class like you would any other class and core data can now store objects of that class and bring them back when needed.


Summary:
+ You define your entities and attributes in core data model.
+ You generate classes from the core data model.
+ you get reference to the persistent container.
+ from persistent container you get a managed object context.
+ through object context we can create and store objects ,etc.. for retrieval for later use.

# Project Work

![Simulator Screen Shot - iPhone 11 - 2023-02-20 at 15 13 25](https://user-images.githubusercontent.com/63160825/220070187-c1dde846-76ee-4329-a4ce-0cf246a05ff6.png)

Working with core data, follow the following steps:
+ Define the entities and attributes
+ Generate Classes in the Model
+ Get a reference to the Core Data persistent container.
+ Get the managed object context.

## Define the entities and attributes

When creating the entity in .xcdatamodel file, we come across different section and one of them is CodeGen. While defining the CodeGen as Class Definition it will automatically creates your database file and they are not visible so we can’t change it, that is why we use Manually so that those files are visible.
As if want to add custom logic or custom method we can apply then. In short in Manual we have full control, in class definition we have no control and in category/ Extension will generate half of it for you. 

## Generate Classes in the Model

Editor -> Create NSManagedObject  Subclass… and creates files
As we can see we get new files added which are the NSManagedObject file and its extension, we get these file selecting the CodeGen value is Manually so that we can make changes and add custom logic. If we would select the CodeGen method as Class Definition then these NSManagedObject files would not be visible and they will be behind the scene. Working would be the same in both CodeGen category but the drawback of class definition option is that we can’t manually change or add the custom logic or method.
And last if selected Category/Extension option than it will create half part visible so that you can modify and other half part un-visible.

## Get a reference to the Core Data persistent container.

In App Delegate we will notice it has created a persistentContainer with name of our data, so that we can access the persistent container from any VC. 
To access the persistent container from the app delegate and manage object context by ".viewContext"
 (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
As we know we can’t use Persistent Container directly so we use .viewContext to access the Persistent Container.
In the app delegate we have another method that is saveContext Method which is helping us in getting reference to the managed object context and detecting if there has been any changes  to the data and then saving.
Alright, so when we start new Xcode project and we enable core data from the back, we get the core data file included in the App Delegate we have the method to access the Core Data persistent container and managed the object context.  

## Get the managed object context.

To access the view context of Persistent Container:
```swift
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
```

To fetch data from the CoreData:
```swift
var items: [Person]?

// Person is a NSManagedObject Class that holds some properties.
do {
    let request = Person.fetchRequest() as NSFetchRequest<Person>
    self.items = try context.fetch(request)
    print(self.items)
} catch {
    print("Unable to fetch request")
}
```

To save data into the Core Data:
```swift
let newPerson = Person(context: self.context)
newPerson.name = "Aman"
newPerson.age = 22
newPerson.gender = "Male"

do{
    try self.context.save()
} catch {
    print("Error in saving the data")
}
```

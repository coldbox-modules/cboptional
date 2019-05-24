# CB Optional

Welcome to the wonderful world of functional programming inspired by Java Optionals (https://docs.oracle.com/en/java/javase/11/docs/api/java.base/java/util/Optional.html#ifPresent(java.util.function.Consumer).  This module will make your life very happy :heart_eyes: and :rocket: accelerate your functional processes as you will **never** have to deal with null values ever again.

## What is a cbOptional?

An `cbOptional` is a simple functional class that wraps a value which can exist or be **null**.  Then you can use all the functions to interact/retrieve or do all kinds of operations on the value. Let's visit a simple example of retrieving an item from a cache, which can produce nulls:

```java
// How many times have we had to do this? Very imperative.
var results = cache.get( "my-key" );
if( isNull( results ) ){
	// do something
} else{
	// use it.
}
```

As you can see above, the code is very imperative, retrieving the results from the cache and acting upon its existence. Now, let's use an optional:

```java
return cache
	.get( "my-key" )
	.orElse( "default" );

cache
	.get( "my-key" )
	.ifPresent( function( value ){
		// Do somethign with the value
	})
	.orElseGet( function(){
		return // something else with the value
	});
```

## Usage

You will need to retrieve optionals using WireBox via it's injection DSL: `@cbOptional`.  Or you can use a full `new cbOptional.models.cbOptional()` if not in ColdBox mode.

```java
getInstance( "@cbOptional" );
```

### Creating Optionals

There are many methods to create optionals:

* `init()` - An empty optional
* `init( value )` - Seed an optional with a value
* `empty()` - Return an empty optional
* `of( value )` - Return an optional of the passed NON null value
* `ofNullable( value )` - Return an optional of the passed existent or possible null value

### Testing For Values

The following methods are for testing the existence of a value in the optional

* `isPresent()` - true if the value is set
* `isEmpty()` - false if the value is NOT set
* `isEqual( optional )` - Tests if the passed optional's value is the same as the optional value called. If both are empty, this is true

### Actions 

You can also do actions and return different values if needed

* `ifPresent( consumer )` - If the value is set, the `consumer` closure or lambda is called for you with a single argument, the value.
* `ifPresentOrElse( consumer, runnable )` - If the value is set, the `consumer` closure or labmda is called, else the `runnable` closure/lambda is called.
* `filter( predicate )` - If a value is present and the value matches the given predicate closure/lambda, the optional with that value is returned or an empty optional
* `map( mapper )` - If a value is present, it will be passed through the mapper function/closure and a new optional with the return value of the mapper will be returned.
* `get()` - Retrieve the value or an exception if it doesn't exist.
* `orElse( other )` - Return the value if present, otherwise return `other`.
* `orElseRun( runnable )` - If the value is NOT present, then run the `runnable` closure or labmda.
* `orElseGet( supplier )` - Return the value if present, otherwise invoke `supplier` and return the result of that invocation.
* `or( supplier ), $or( supplier )` - If a value is present, returns an Optional describing the value, otherwise returns an Optional produced by the supplying function.
* `orElseThrow( type, message )` - If a value is present, returns the value, otherwise throws `NoSuchElementException` or your own type and message.

### Utility functions

* `hashCode()` - Returns the hash code value of the present value, if any, or 0 (zero) if no value is present.
* `toString()` - Returns a non-empty string representation of this Optional suitable for debugging.

********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
#### HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

>"Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD
 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12

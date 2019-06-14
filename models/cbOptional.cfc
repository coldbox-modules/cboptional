/**
 * A container object which may or may not contain a non-null value. If a value is present, isPresent() will return true and get() will return the value.
 *
 * Additional methods that depend on the presence or absence of a contained value are provided, such as orElse() (return a default value if value not present) and ifPresent() (execute a block of code if the value is present).
 *
 * This object is highly inspired by Java Optionals to bring a more functional process to dealing with values that might or not exist.
 */
component{

	/**
	* The value we represent
	*/
   property name="value";

   // Adobe CF Hack because their compiler sucks!
   this[ "or" ] = this.$or;

	/**
	 * Construct a CB Optional
	 * If no value passed, we will generate an empty one.
	 *
	 * @value The value to represent or null
	 */
	cbOptional function init( value ){
		if( !isNull( arguments.value ) ){
			variables.value = arguments.value;
		} else {
			variables.value = javaCast( "null", "" );
		}
		return this;
	}

	/**
	 * Set's a value and returns an optional of it
	 *
	 * @value The value to be present, which must be NON NULL or an exception is  thrown
	 *
	 * @return an Optional with the value present
	 * @throws NullPointerException
	 */
	cbOptional function of( required value ){
		if( isNull( arguments.value ) ){
			throw(
				message = "Cannot set a null value using the of() method",
				type = "NullPointerException"
			);
		}
		return new cbOptional( arguments.value );
	}

	/**
	 * Returns an Optional describing the specified value, if non-null, otherwise returns an empty Optional.
	 *
	 * @value the possibly-null value to describe
	 *
	 * @return an Optional with a present value if the specified value is non-null, otherwise an empty Optional
	 */
	cbOptional function ofNullable( value ){
		if( isNull( arguments.value ) ){
			return this.empty();
		} else {
			return this.of( arguments.value );
		}
	}

	/**
	 * Build an empty optional out.
	 */
	cbOptional function empty(){
		return new cbOptional();
	}

    /**
	* Return true if there is a value present, otherwise false.
	*/
	boolean function isPresent(){
		return !isNull( variables.value );
	}

	/**
	* Return true if there is no value present, otherwise false
	*/
	boolean function isEmpty(){
		return !this.isPresent();
	}

	/**
	 * Indicates whether some other object is "equal to" this Optional. The other object is considered equal if:
	 * it is also an Optional and;
	 * both instances have no value present or;
	 * the present values are "equal to" each other
	 *
	 * Please note that the incoming <source>obj</source> must also be an Optional
	 *
	 * @optional
	 */
	boolean function isEqual( required optional ){
		if( !isInstanceOf( arguments.optional, "cbOptional" ) ){
			return false;
		}
		if( arguments.optional.isEmpty() && this.isEmpty() ){
			return true;
		}

		return this.get() == arguments.optional.get();
	}

	/**
	 * If a value is present, invoke the specified consumer closure/lambda with the value, otherwise do nothing.
	 * The consumer received the value of this optional: (value) => {}, function( value ){}
	 *
	 * This method returns the same cbOptional instance, so you can concatenate it to call multiple consumers
	 *
	 * @consumer block to be executed if a value is present
	 *
	 * @return The same instance
	 */
	cbOptional function ifPresent( required consumer ){
		if( this.isPresent() ){
			arguments.consumer( this.get() );
		}
		return this;
	}

	/**
	 * If a value is present, performs the given action with the value, otherwise performs the given empty-based action.
	 *
	 * @consumer The closure/lambda to execute if the value is present
	 * @runnable The closure/lambda to execute if the value is NOT present
	 */
	void function ifPresentOrElse( required consumer, required runnable ){
		if( this.isPresent() ){
			arguments.consumer( this.get() );
		}
		arguments.runnable();
	}

	/**
	* If a value is present, and the value matches the given predicate, returns an Optional describing the value, otherwise returns an empty Optional.
	*
	* @predicate a predicate to apply to the value, if present
	*
	* @return an Optional describing the value of this Optional if a value is present and the value matches the given predicate, otherwise an empty Optional
	*/
	cbOptional function filter( required predicate ){
		if( this.isPresent() ){
			return (
				arguments.predicate( this.get() ) ?
				this :
				this.empty()
			);
		}

		return this;
	}

	/**
	* If a value is present, apply the provided mapping function to it, and if the result is non-null, return an Optional describing the result. Otherwise return an empty Optional.
	*
	* @mapper a mapping function to apply to the value, if present
	*
	* @return an Optional describing the result of applying a mapping function to the value of this Optional, if a value is present, otherwise an empty Optional
	*/
	cbOptional function map( required mapper ){
		if( this.isPresent() ){
			return this.ofNullable( arguments.mapper( this.get() ) );
		}
		return this;
	}

	/**
	* If a value is present in this Optional, returns the value, otherwise throws NoSuchElementException.
	*/
	any function get(){
		if( this.isPresent() ){
			return variables.value;
		}
		throw( type="NoSuchElementException", message="Value does not exist" );
	}

	/**
	* Return the value if present, otherwise return other.
	*
	* @other the value to be returned if there is no value present, may be null
	*
	* @return the value, if present, otherwise other
	*/
	any function orElse( required other ){
		return ( this.isPresent() ? this.get() : arguments.other );
	}

	/**
	* Return the value if present, otherwise invoke other and return the result of that invocation.
	*
	* @supplier a Supplier lambda or closure whose result is returned if no value is present
	*
	* @return the value if present otherwise the result of other.get()
	*/
	any function orElseGet( required supplier ){
		return ( this.isPresent() ? this.get() : arguments.supplier() );
	}

	/**
	* Runs the `runnable` closure/lambda if the value is not set and the same optional instance is returned.
	*
	* @runnable a lambda or closure that will run
	*
	* @return the same optional instance
	*/
	cbOptional function orElseRun( required runnable ){
		if( !this.isPresent() ){
			arguments.runnable();
		}
		return this;
	}

	/**
	 * If a value is present, returns an Optional describing the value, otherwise returns an Optional produced by the supplying function.
	 *
	 * @supplier A closure/lambda that must return a cbOptional
	 */
	cbOptional function $or( required supplier ){
		if( this.isPresent() ){
			return this;
		}
		return arguments.supplier();
	}

	/**
	 * If a value is present, returns the value, otherwise throws NoSuchElementException.
	 *
	 * @type The type of the exception to throw or defaults to NoSuchElementException,
	 * @message The message of the exception, defaults to empty string
	 */
	any function orElseThrow( type="NoSuchElementException", message="" ){
		if( this.isPresent() ){
			return this.get();
		}
		throw( type=arguments.type, message=arguments.message );
	}

	/**
	 * Returns the hash code value of the present value, if any, or 0 (zero) if no value is present.
	 */
	numeric function hashCode(){
		return (
			this.isPresent() ?
			createObject( "java", "java.lang.System" ).identityHashCode( variables.value ) :
			0
		);
	}

	/**
	 * Returns a non-empty string representation of this Optional suitable for debugging.
	 * If empty it returns an empty string
	 */
	String function toString(){
		return (
			this.isPresent() ?
			variables.value.toString() :
			""
		);
	}

}
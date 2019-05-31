component extends="testbox.system.BaseSpec"{

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "CB Optional", function(){

			story( "I can create optionals", function(){
				given( "nothing to the constructor", function(){
					then( "it should build an empty optional", function(){
                        var optional = new cbOptional.models.cbOptional();
                        expect( optional.isPresent() ).toBeFalse();
					});
                });
                given( "a value to the constructor", function(){
					then( "it should build it with that value", function(){
                        var optional = new cboptional.models.cbOptional(
                            "luis"
                        );
                        expect( optional.isPresent() ).toBeTrue();
					});
				});
            });

            it( "can equal optionals", function(){
                var optional = new cboptional.models.cbOptional();
                expect( optional.isEqual(
                    "test"
				 ) ).toBeFalse();
				 var optional = new cboptional.models.cbOptional( "luis" );
				 var optional2 = new cboptional.models.cbOptional( "luis" );
				 expect( optional.isEqual( optional2 ) ).toBeTrue();
            } );

            it( "can get a hash code", function(){
                var optional = new cboptional.models.cbOptional(
                    "luis"
                );
                expect( optional.hashcode() ).notToBeEmpty();
			} );
			it( "can get a hash code when empty", function(){
                var optional = new cboptional.models.cbOptional();
                expect( optional.hashcode() ).toBe( 0 );
            } );

            it( "can invoke if present consumers", function(){
                var consumerValue = "";

                var optional = new cboptional.models.cbOptional().of( "luis" );
                    optional
                    .ifPresent( function( e ){
                        consumerValue = e;
                    } );

                expect( consumerValue ).toBe( "luis" );
			} );


			it( "can filter results", function(){
				expect(
					new cboptional.models.cbOptional()
					.of( 2016 )
					.filter( function( item ){ return item == 2016; } )
					.isPresent()
				).toBeTrue();

				expect(
					new cboptional.models.cbOptional()
					.of( 2016 )
					.filter( function( item ){ return item == 2017; } )
					.isEmpty()
				).toBeTrue();
			});


			it( "can map results", function(){
				var opt = new cboptional.models.cbOptional()
					.of( 2016 )
					.map( function( value ){ return value+1; } );
				expect( opt.isPresent()	).toBeTrue();
				expect( opt.get()	).toBe( 2017 );

				var opt = new cboptional.models.cbOptional()
					.of( 2016 )
					.map( function( value ){ return; } );
				expect( opt.isPresent()	).toBeFalse();
			});


			it( "can get results", function(){
				var opt = new cboptional.models.cbOptional().of( 2016 );
				expect( opt.get() ).tobe( 2016 );

				var opt = new cboptional.models.cbOptional();
				expect( function(){ opt.get(); } ).toThrow();
			});

            it( "can return orElse() ", function(){
                var optional = new cboptional.models.cbOptional();
                expect( optional.orElse( "luis" ) ).toBe( "luis" );

                var optional = new cboptional.models.cbOptional().of( "alexia" );
                expect( optional.orElse( "luis" ) ).toBe( "alexia" );
            } );

            it( "can return orElseGet() ", function(){
                var optional = new cboptional.models.cbOptional();
                expect( optional.orElseGet( function(){
                    return "luis";
                } ) ).toBe( "luis" );
            } );

            it( "can return toString() representations ", function(){
                var optional = new cboptional.models.cbOptional().of( "luis" );
                expect( optional.toString() ).toInclude( "luis" );
			} );

			it( "can do orElseThrow()", function(){
                var optional = new cboptional.models.cbOptional();
                expect( function(){
					optional.orElseThrow();
				} ).toThrow();
			} );


			it( "can do an or with another optional", function(){
				var optional = new cboptional.models.cbOptional()
					.$or(
						function(){
							return new cboptional.models.cbOptional( "luis" );
						}
					);
				expect( optional.get() ).toBe( "luis" );
			});

		});

	}

}
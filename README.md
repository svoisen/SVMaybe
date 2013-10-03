SVMaybe
=======

A simple [Maybe monad](http://en.wikipedia.org/wiki/Monad_\(functional_programming\)#The_Maybe_monad) implementation in Objective-C.

Overview
--------

SVMaybe provides the following:

1. An elegant solution to the common problem of nested ```nil``` checks in Objective-C code.
2. Custom definitions of what is meant by "nothing" on a per-class basis ("semantic nil").

If you've ever found yourself writing something tedious like this:

```objc
NSDictionary *person = @{@"name":@"Homer Simpson", @"address":@{@"street":@"123 Fake St", @"city":@"Springfield"}};
NSString *cityString;

if (person)
{
    NSDictionary *address = (NSDictionary *)[person objectForKey:@"address"];
    if (address)
    {
        NSString *city = (NSString *)[address objectForKey:@"city"];
        if (city)
        {
            cityString = city;
        }
        else
        {
            cityString = @"No city."
        }
    }
    else
    {
        cityString = @"No address.";
    }
}
else
{
    cityString = @"No person.";
}
```
    
SVMaybe allows you to more concisely and declaratively provide the same solution:

```objc
NSDictionary *person = @{@"name":@"Homer Simpson", @"address":@{@"street":@"123 Fake St", @"city":@"Springfield"}};
NSString *cityString = [[[Maybe(person) whenNothing:Maybe(@"No person.") else:MapMaybe(person, [person objectForKey:@"address"])]
                                        whenNothing:Maybe(@"No address.")] else:MapMaybe(address, [address objectForKey:@"city"])]
                                        whenNothing:Maybe(@"No city.")] justValue];
```

It also allows you to move beyond simple ```nil``` checks by offering run-time redefinition of what is meant by "nothing" on a per-class basis. For instance, in the above example suppose that empty strings should also be considered "nothing." Here's the re-definition:

```objc
[NSString defineNothing:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
    return [(NSString *)evaluatedObject length] == 0;
}]];
```

Given this re-definition, if any of the strings in the above example were empty (or nil), the monad binding would short to nothing and return the appropriate default string wrapped in a SVMaybe.

Creating Maybes
---------------

Use the provided macro:

```objc
Maybe(@"foo");
Maybe(nil);
```

Or a static method:

```objc
[SVMaybe maybe:@"foo"];
[SVMaybe maybe:nil]; // Equals [SVMaybe nothing]
```

Getting Values
--------------

To get the value of a maybe:

```objc
[Maybe(@"foo") justValue] // "foo"
[Nothing justValue] // Throws an exception!
```

Binding and Chaining
--------------------

SVMaybe offers a few other chaining options in addition to ```whenNothing:else``` described above:

* ```andMaybe:``` Binds multiple maybe values together, returning the last bound maybe. If any maybe is "nothing," the binding shorts and returns "nothing." (Equivalent to ```>>``` in Haskell.)

* ```whenSomething:``` Binds and maps multiple maybes together using the provided block. If any maybe is "nothing," the binding shorts and returns "nothing." (Equivalent to ```>>=``` in Haskell.)

* ```whenNothing:``` Same as ```whenNothing:else:``` but without the else block. Returns ```self``` if not nothing.

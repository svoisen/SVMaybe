SVMaybe
=======

A simple Maybe monad implementation in Objective-C.

Overview
--------

SVMaybe provides the following:

1. An elegant solution to the common problem of nested ```nil``` checks in Objective-C code.
2. Custom definitions of what is meant by "nothing" on a per-class basis ("semantic nil").

If you've ever found yourself writing something tedious like this:

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
    
SVMaybe allows you to more concisely and declaratively provide the same solution:

    NSDictionary *person = @{@"name":@"Homer Simpson", @"address":@{@"street":@"123 Fake St", @"city":@"Springfield"}};
    NSString *cityString = [[[Maybe(person) whenNothing:Maybe(@"No person.") else:MapMaybe(person, [person objectForKey:@"address"])]
                                            whenNothing:Maybe(@"No address.")] else:MapMaybe(address, [address objectForKey:@"city"])]
                                            whenNothing:Maybe(@"No city.")] justValue];
   

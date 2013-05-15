use Test::More;
use Types::Classes -all;
use Test::Fatal;

like exception { InstanceOf }, qr/Wrong number of parameters/, 'parameters are required';

ok(
  !(InstanceOf['MyClass'])->check('string'),
  'InstanceOf rejects strings');

ok(
  (InstanceOf['MyClass'])->check(bless {}, 'MyClass'),
  'InstanceOf accepts objects of correct class');

ok(
  !(InstanceOf['MyClass'])->check(bless {}, 'MyClass2'),
  'InstanceOf rejects objects of wrong class');

ok(
  (InstanceOf['MyClass','MyClass2'])->check(bless {}, 'MyClass2'),
  'InstanceOf accepts objects of correct class with multiple');

ok(
  (InstanceOf['MyClass','MyClass2'])->check(bless {}, 'MyClass'),
  'InstanceOf accepts objects of correct class with multiple');


sub MyClass::DOES {
  return 1
    if $_[1] eq 'MyRole';
}

sub MyClass2::DOES {
  return 1
    if $_[1] eq 'MyRole'
      or $_[1] eq 'MyRole2';
}
sub MyClass3::DOES {
  return 1
    if $_[1] eq 'MyRole2';
}


ok(
  !(ConsumerOf['MyRole'])->check('string'),
  'ConsumerOf rejects strings');

ok(
  (ConsumerOf['MyRole'])->check(bless {}, 'MyClass'),
  'ConsumerOf accepts objects consuming correct role');

ok(
  !(ConsumerOf['MyRole'])->check(bless {}, 'MyClass3'),
  'ConsumerOf rejects objects not consuming correct role');

ok(
  (ConsumerOf['MyRole','MyRole2'])->check(bless {}, 'MyClass2'),
  'ConsumerOf accepts objects consuming correct roles');

ok(
  !(ConsumerOf['MyRole','MyRole2'])->check(bless {}, 'MyClass3'),
  'ConsumerOf rejects objects consuming only second role');

ok(
  !(ConsumerOf['MyRole','MyRole2'])->check(bless {}, 'MyClass'),
  'ConsumerOf rejects objects not consuming all roles');


sub MyClass::method1 { }
sub MyClass::method2 { }
sub MyClass2::method1 { }


ok(
  !(HasMethods['method1'])->check('string'),
  'HasMethods rejects strings');

ok(
  (HasMethods['method1'])->check(bless {}, 'MyClass'),
  'HasMethods accepts objects with correct method');

ok(
  !(HasMethods['method1'])->check(bless {}, 'MyClass3'),
  'HasMethods rejects objects without correct method');

ok(
  (HasMethods['method1','method2'])->check(bless {}, 'MyClass'),
  'HasMethods accepts objects with correct methods');

ok(
  !(HasMethods['method1','method2'])->check(bless {}, 'MyClass2'),
  'HasMethods rejects objects with not implementing all methods');


ok(
  (Enum['string', 'string2'])->check('string'),
  'Enum accepts string in enum');

ok(
  !(Enum['string', 'string2'])->check('string3'),
  'Enum rejects string not in enum');

done_testing;


// Variadic Arguments in Core Foundation Method
var array = NSArray.arrayWithObjects_(72, 2, 3);

// Variaidc Arugments In Your-Defined Method
ViewController.test_(1, 2, 4, 7);

// Custom Class Methods
ViewController.printNSArray_(array);

// Invalid Function Call Cause JSException And Leads To Stop Evaluating Script
// ViewController.testStr_value_("wuziqi niubi", 1.0, 2.0, 7.0);

// Choose
var label = choose(UILabel)[0];

// Setter
label.text = "WZQTQL";

// Using Method Insteat Of Getter
var tex = label.text();

var vc = choose(ViewController)[0];

// Instance Method
vc.printName_(tex);

// Chainable Calling Method
vc.view().setBackgroundColor_(UIColor.redColor());

// Struct
var frame = vc.view().frame();

frame.origin.x = 100;

vc.view().frame = frame;

//  Treat Struct As A Plain JavaScript Object
label.frame = {origin:{x:0, y:10}, size:{width:200, height:100}};

// Pointer
var intP = vc.allocAddressWithInt();
vc.testIntPointer_(intP);

var doubleP = vc.allocAddressWithDouble();
vc.testDoublePointer_(doubleP);

var charP = vc.allocAddressWithChar();
vc.testCString_(charP);

// AssociateObject
var aso = TestAssociateObject.alloc().init();
vc.associateObject = aso;
vc.print();

aso.associateInt = 5;

vc.print();

// Get AssoicateObject Directly
var asovalu = aso.associateInt;

vc.printNumb_(asovalu);





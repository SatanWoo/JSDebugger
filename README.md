# JSDebugger

**JavaScript-Based Debugger For Inspecting Running State Of Your Application**

> The status of this project is under rapid development, the stability is not guaranteed

JSDebugger is a runtime inspecting tool for you to dig into details of your applications.

It's built on top of JavaScriptCore within C level interface which aims to accelerate the bridging process between Objective-C and JavaScript.

## Usage

### Methods

	var view = UIView.alloc().init();
	view.setBackgroundColor_(UIColor.redColor());
	
You may notice the method name is to some extent different from Objective-C environment. To illustrate it more precisely, the following two steps are executed underlying before calling an Objective-C method:

- All colons are converted to underscores.
- Each part of the Objective-C selector is concatenated into single string.

For Example:

	application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	
will be converted into following string:

	application_didFinishLaunchingWithOptions(application, launchOptions)


### Getter & Setter

	view.backgroundColor = UIColor.redColor();
	var color = view.backgroundColor;
	var bounds = view.bounds;

<b style="color:red">Don't Mix Getter With Calling Methods!</b>   

For Example:

	view.backgroundColor;   // It's Correct
	
	view.backgroundColor(); // It's Wrong
	
### JavaScript

The running context of **JSDebugger** is totally the same as an ordinary JavaScript file. You can do whatever your want in **JSDebugger** as long as it satisfied the requirement of JavaScript:

	var z = 5;
	
	var k = [1, 2, 3];
	
	var z = {name:'haha', age:15, data:k};
	

## Plugin

Excluded from the core functions provided with **JSDebugger**, we develop plugin mechanism for you to enhance the ability that **JSDebugger** able to cover.

### Choose

`Choose` aims to provide your with the ability to access any objects on heaps. The function will search all instances that match the class name you provided **exactly** and return all found results as an array.

For Example, suppose you have a class named `XXXViewController`

	var vc = choose(XXXViewController);
	
Then you will make some operation on it:

	vc.isViewLoaded;
	var view = vc.view;
	view.backgroundColor = UIColor.orangeColor();

## Playground

We provide you with a mechansim to debug instantly with the help of **JSDebugger Playground**

It's already integrated into **JSDebugger**. The usage of it is quite simple, suppose you have a `test.js` on your `Desktop`. 

Follow steps listed below, 

1. include `'JDLocalFileObserver.h'` and declare a reference to it.

	`@property (nonatomic, strong) JDLocalFileObserver *fileWatcher;`
	
2. Init it with path to your `test.js` and file change callback.

		NSString *jsFilePath = @"PathToDesktop/test.js";
	    
	    if ([[NSFileManager defaultManager] fileExistsAtPath: jsFilePath]) {
	        self.fileWatcher = [[JDLocalFileObserver alloc] initWithFilePath: jsFilePath changeBlock:^{
	            NSLog(@"[JSDebugger]::found test.js change");
	            dispatch_async(dispatch_get_main_queue(), ^{
	                [[JDEngine engine] evaluateScriptAtPath: jsFilePath];
	            });
	        }];
	        [self.fileWatcher start];
	    }

3. Now, whenever you change something in your `test.js` and save it, your will find **JSDebugger** automatically reload the content of `test.js` and start to evaluate it.

4. **Do not forget to stop the local file watch**

		[self.fileWatch stop]

## Example

Checkout the JSDebuggerDemo

## Contribution

- JunyiXie

## Features:

Here we list all features currently supported by **JSDebugger**:
- [x] Class Methods  
- [x] Instance Methods  
- [x] Instance Property 
- [x] Custom Getter & Setter
- [x] Playground
- [x] Data Structes: `primitive types`, `object`, `class`, `struct` (Partially)
- [x] Choose  
- [x] Introspect (Partially)
- [ ] Block
- [ ] C Pointers

**<span style="color:red">Blocks and C Pointers is not ready within this version of JSDebugger</span>**

## What's Next

An IDE with live Objective-C to JavaScript convertion is under development.   
You can really look forward to it!


## Reference

The great works listed below inspired me a lot during the development of **JSDebugger**.

- Cycript 
- [JSPatch](https://github.com/bang590/JSPatch) @Bang
- [Choose](https://github.com/BlueCocoa/choose) @BlueCocoa

## License

Copyright 2018 @SatanWoo

Checkout [License](https://github.com/SatanWoo/JSDebugger/blob/master/LICENSE)

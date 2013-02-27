#SMFileIterator

This class iterates trough a folder hierarchy and returns the paths to all files and folder. The interaction with the paths is block based. 

There are also several options like `pathRegex` and `fileExtension` to filter the paths.

##Examples

For all of the following examples this folder hirarchy is used:

	.
	├── ADCTests
	│   ├── Makefile
	│   ├── lcd-routines.c
	│   ├── lcd-routines.h
	│   ├── lcd-routines.o
	│   ├── main.c
	│   ├── main.elf
	│   ├── main.hex
	│   └── main.o
	└── ADCTests.xcodeproj
	    ├── project.pbxproj
	    ├── project.xcworkspace
	    │   ├── contents.xcworkspacedata
	    │   └── xcuserdata
	    │       └── MyUser.xcuserdatad
	    │           └── UserInterfaceState.xcuserstate
	    └── xcuserdata
	        └── MyUser.xcuserdatad
	            └── xcschemes
	                ├── build.xcscheme
	                ├── flash.xcscheme
	                ├── fuse.xcscheme
	                └── xcschememanagement.plist
	                
###Example \#1

**Source**

	SMFileIterator *iterator = [[SMFileIterator alloc] initWithPath:PATH_TO_FOLDER];
	iterator.pathBlock = ^(NSString *path, BOOL isDir) {
	    NSLog(@"%@", path);
	};
	[iterator start];

**Output**

	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests
  	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/lcd-routines.h
  	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/lcd-routines.c
  	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/lcd-routines.o
  	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/main.c
  	...
  	
This example returns all paths to all of the files above. The paths are all absolute on the filesystem.
  	
###Example \#2

**Source**

    SMFileIterator *iterator = [[SMFileIterator alloc] initWithPath:PATH_TO_FOLDER];
    NSMutableString *text = [NSMutableString stringWithString:@"Files in NSHomeDirectory(): \n\n"];
    iterator.fileExtension = @"c";
    iterator.pathBlock = ^(NSString *path, BOOL isDir) {
       NSLog(@"%@", path);
    };
    [iterator start];
    
**Output**

	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/lcd-routines.c
	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests/main.c


This example only lists pathes to files that have `.c` as its file extension.

###Example \#3

**Source**

	SMFileIterator *iterator = [[SMFileIterator alloc] initWithPath:@"/Users/MyUser/Desktop/AVR Tests/ADCTests"];            
    NSString *pattern = @".*xcschemes/.*";
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    iterator.pathRegex = exp;
    iterator.pathBlock = ^(NSString *path, BOOL isDir) {
       NSLog(@"%@", path);
    };
    [iterator start];
**Output**

	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests.xcodeproj/xcuserdata/MyUser.xcuserdatad/xcschemes/build.xcscheme
	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests.xcodeproj/xcuserdata/MyUser.xcuserdatad/xcschemes/flash.xcscheme
	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests.xcodeproj/xcuserdata/MyUser.xcuserdatad/xcschemes/fuse.xcscheme
	/Users/MyUser/Desktop/AVR Tests/ADCTests/ADCTests.xcodeproj/xcuserdata/MyUser.xcuserdatad/xcschemes/xcschememanagement.plist
	
This example uses a regular expression to only return files in the folder called `xcschemes`.

##Feater requests

If you would like to see another feature that is not implement, just open an issue or implement it yourself and send me a pull request. If I get some time, I will implement it.

## License (MIT)

Copyright (C) 2012 FidelisFactory

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

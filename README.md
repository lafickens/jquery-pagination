# jQuery Pagination Plugin

This is a simple jQuery pagination plugin written in CoffeeScript.

## Dependencies

* jQuery >= 1.7

* Bootstrap >= 2.2.1

Note: This plugin is developed with the constraint of complying with IE6. The Bootstrap framework usable on IE6 is v2.2.1. This plugin should theoretically work with newest version of Bootstrap, but still further tests are required.

## Transpiling to JavaScript

1. Install [node.js](http://nodejs.org) first

2. Install CoffeeScript compiler
```bash
npm install coffee-script
```

3. Navigate to the directory where .coffee resides
```bash
coffee -c -o [library directory] [source directory]
```

## Usage

After getting the jQuery object on an HTML element, simply run:
```javascript
$(your-own-selection).paginate(options);
```

The options parameter is a plain JavaScript object, defined as:
```javascript
var options = {
	remote: false, // Required. Whether to retrieve remote information
	url: "http://example.com", // Required if remote is true. The URL to retrieve information from
	method: "get" // Optional. Defaults to GET
	limit: 5, // Required. Number of items to display on one page
	headerRow: ["a", "b"] // Required. Header row definition
	values: [ // Required. Set table values
			{
				id: 1, // Totally arbitrary, but a unique identifier is recommended
				data: ["foo", "bar"] // Must exactly match the order of headerRow
			},
			{
				id: 2,
				data: ["lorem", "ipsum"]
			}
	],
	buttons: { // Optional. Define buttons at the end of each row
		// "Fantastic" will be the value of button, and the value is the handler
		"Fantastic!": function(id, data) { // id and data are the row values passed in above
			alert("Something");
		},
		// You can use HTML in key
		"<i class="icon-plus">": function(id, data) {
			alert("Even better.");
		}
	}
}
```

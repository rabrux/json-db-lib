# json-db-lib
Database library for lightweight databases based on JSON files.

### Installation

Terminal
>```
npm install json-db-lib
```

### Usage

>```javascript
...
var db = require ('json-db-lib');
...
```

### Functions

| Function | Description |
| - | - |
| connect( path ) | It set the work directory .The **path** argument is the physical directory where the database json files will be saved. |
| load( table, init ) | This function load or create a table json file in the working directory. The **table** argument is the name of your json data table. The **init** argument can takes two initializations: to initialize an collection set the init param to **[]**, to initialize an object just set the init param to **{}**. |
| insert( table, obj ) | This function add a new object (obj) in the collection (table). |
| select( table, query, values ) | The select function returns a vector with of the collection **table** that match with the search **query**, the *query* param looks like "user == :user AND password == :password", and the values param is an object key: value, the keys must be equal to the query variables preceded by : |
| update( table, obj, find ) | This function update with **obj** the elements that match with the search criteria contained in **find** object into collection **table**. |
| delete( table, query, values ) | The delete function remove all objects that match with the **query** criteria like a select function. |
| save() | It save the collection into json file. |

### Example

>```javascript
...
var db = require('json-db-lib');
db.connect( './data' );
db.load( 'user', [] );
var user = {
  login: 'lorem',
  pass: 'access',
  name: 'Loremso Ipsumo',
  email: 'loremso@example.com'
};
db.insert( 'user', user );
...
```

### Credits

This project has been created by [Raúl Salvador Andrade](http://github.com/rabrux) and is sponsored by [WA Technologies](http://wat.mx)

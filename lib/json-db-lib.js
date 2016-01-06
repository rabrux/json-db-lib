// Generated by CoffeeScript 1.10.0
(function() {
  var db, fs;

  fs = require('fs');

  db = {
    path: null,
    tableFile: null
  };

  db.connect = function(path) {
    var e, error, stats;
    if (path) {
      try {
        stats = fs.lstatSync(path);
        if (stats.isDirectory()) {
          this.path = path.replace(/\/$/, '') + '/';
        } else {
          throw 'Invalid directory';
          process.exit(1);
        }
      } catch (error) {
        e = error;
        console.log(e);
      }
    } else {
      throw 'Undefined path';
    }
  };

  db.load = function(table, init) {
    var e, error;
    if (table) {
      try {
        this.table = JSON.parse(fs.readFileSync(this.path + table + '.json', 'utf8'));
        this.tableFile = table + '.json';
      } catch (error) {
        e = error;
        this.table = init;
        this.tableFile = table + '.json';
        this.save();
      }
    }
  };

  db.insert = function(table, obj) {
    this.load(table);
    this.table.push(obj);
    return this.save();
  };

  db.select = function(table, query, values) {
    var i, j, k, l, len, len1, r, ref, ref1, result, v;
    query = query || '1=1';
    this.load(table);
    result = [];
    r = [];
    ref = query.split(/\s(AND|OR)\s/);
    for (j = 0, len = ref.length; j < len; j++) {
      i = ref[j];
      if (i !== 'AND' && i !== 'OR') {
        i = 'i.' + i;
      }
      r.push(i);
    }
    query = r.join(' ');
    for (k in values) {
      v = values[k];
      if (typeof v === 'string') {
        query = query.split(k).join('"' + v + '"');
      } else {
        query = query.split(k).join(v);
      }
    }
    query = query.split(' AND ').join(' && ');
    query = query.split(' OR ').join(' || ');
    query = 'e = ' + query;
    ref1 = db.table;
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      i = ref1[l];
      eval(query);
      if (e) {
        result.push(i);
      }
    }
    return result;
  };

  db.update = function(table, obj, find) {
    var i, j, k, len, query, ref, v;
    query = [];
    for (k in find) {
      v = find[k];
      if (typeof v === 'string') {
        query.push('i.' + k + ' == "' + v + '"');
      } else {
        query.push('i.' + k + ' == ' + v);
      }
    }
    query = 'e = ' + query.join(' AND ');
    ref = this.table;
    for (j = 0, len = ref.length; j < len; j++) {
      i = ref[j];
      eval(query);
      if (e) {
        i = obj;
      }
    }
    return this.save();
  };

  db["delete"] = function(table, query, values) {
    var delIndex, i, j, k, l, len, len1, pos, r, ref, ref1, result, v;
    this.load(table);
    result = [];
    r = [];
    ref = query.split(/\s(AND|OR)\s/);
    for (j = 0, len = ref.length; j < len; j++) {
      i = ref[j];
      if (i !== 'AND' && i !== 'OR') {
        i = 'i.' + i;
      }
      r.push(i);
    }
    query = r.join(' ');
    for (k in values) {
      v = values[k];
      if (typeof v === 'string') {
        query = query.split(k).join('"' + v + '"');
      } else {
        query = query.split(k).join(v);
      }
    }
    query = query.split(' AND ').join(' && ');
    query = query.split(' OR ').join(' || ');
    query = 'e = ' + query;
    delIndex = [];
    pos = 0;
    ref1 = this.table;
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      i = ref1[l];
      eval(query);
      if (e) {
        delIndex.push(pos);
      }
      pos++;
    }
    while (delIndex.length > 0) {
      this.table.splice(delIndex.pop(), 1);
    }
    return this.save();
  };

  db.save = function() {
    fs.writeFile(this.path + this.tableFile, JSON.stringify(this.table, null, 4), function(err) {
      if (err) {
        return false;
      }
    });
    return true;
  };

  module.exports = db;

}).call(this);
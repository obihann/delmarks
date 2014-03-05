(function() {
  var authError, connect, deleteLink, fs, help, loadDelicious, newLink, parseAll, parseAllResponse, title, upgrade, url, _;

  fs = require('fs');

  url = require('url');

  _ = require('underscore');

  loadDelicious = function() {
    var data;
    if (!this.user) {
      try {
        data = fs.readFileSync(process.env.HOME + '/.config.dlmrk');
        this.user = JSON.parse(data);
      } catch (_error) {
        return false;
      }
    }
    process.env.DELICIOUS_USER = this.user.username;
    process.env.DELICIOUS_PASSWORD = this.user.password;
    return this.nodedelicious = require('nodedelicious');
  };

  title = function() {
    console.log("Delmarks: A node based command line tool for managing your Del.iciou.us bookmarks (1.0.0)");
    return console.log("-----------------------------------------------------------------------------------------");
  };

  authError = function() {
    title();
    return console.log("Please connect first, try running 'delmarks connect <username> <password>' or if you have recently updated run 'delmarks upgrade'");
  };

  parseAll = function() {
    if (loadDelicious()) {
      return this.nodedelicious.getAllPosts("", "", function(err, data) {
        if (!err) {
          return parseAllResponse(data);
        }
      });
    } else {
      return authError();
    }
  };

  parseAllResponse = function(data) {
    var posts;
    if (data.posts) {
      posts = data.posts.post;
      return _.each(posts, function(link) {
        return console.log(link.$.href);
      });
    }
  };

  deleteLink = function(link) {
    if (loadDelicious()) {
      return nodedelicious.deletePost(link, function(err, data) {
        title();
        if (!err) {
          return console.log("the link (" + link + ") has been removed");
        } else {
          return console.log("an error has occured");
        }
      });
    } else {
      return authError();
    }
  };

  newLink = function(link) {
    if (loadDelicious()) {
      link = url.parse(link);
      return nodedelicious.addPost(link.href, link.hostname, function(err, data) {
        title();
        if (!err) {
          return console.log("the link (" + link + ") has been added");
        } else {
          return console.log("an error has occured");
        }
      });
    } else {
      return authError();
    }
  };

  connect = function(username, password) {
    var data;
    this.user = {
      username: username,
      password: password
    };
    data = JSON.stringify(user);
    fs.writeFile('./config.json', data, function(err) {
      if (err) {
        return console.log(err.message);
      }
    });
    return loadDelicious();
  };

  help = function() {
    title();
    console.log("connect USERNAME PASSWRD: Connect your account");
    console.log("ls: List your bookmarks");
    console.log("add http://google.ca: Add a new bookmark");
    console.log("remove http://google.ca: Removes a bookmark");
    return console.log("upgade: upgrades your account");
  };

  upgrade = function() {
    title();
    console.log("Attempting to upgrade user file...");
    return fs.rename(process.env.HOME + '/config.json', process.env.HOME + '/.config.dlmrk', function(err) {
      if (err) {
        return console.log("User file could not be upgreade, please run 'delmarks connect'");
      } else {
        return console.log("Upgrade complete");
      }
    });
  };

  switch (process.argv[2]) {
    case "upgrade":
      upgrade();
      break;
    case "ls":
      parseAll();
      break;
    case "remove":
      deleteLink(process.argv[3]);
      break;
    case "add":
      newLink(process.argv[3]);
      break;
    case 'connect':
      connect(process.argv[3], process.argv[4]);
      break;
    default:
      help();
  }

}).call(this);
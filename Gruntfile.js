"use strict";

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    coffee: {
      compile: {
        files: {
          'app/app.js': 'src/app.coffee'
        }
      }
    }
  });

  grunt.registerTask('default', ['coffee']);
  grunt.loadNpmTasks('grunt-contrib-coffee');
};
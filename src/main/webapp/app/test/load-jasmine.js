// Generated by CoffeeScript 1.3.1
(function() {
  top_level_specs = ['menu-dataSpec'
  ];
    
  view_jasmine_specs = [
    'AppViewSpec',
    'EditorNodeViewSpec',
    'EditorLinkViewSpec', 
    'MapLinkViewSpec',
    'MapNodeViewSpec'
    //'EditorSensorViewSpec'
  ];
  
  collections_jasmine_specs = [
    'NodeListCollectionSpec', 
    'LinkListCollectionSpec',
    'LinkListViewSpec', 
    'NodeListViewSpec'
    //'SensorListCollectionSpec', 'SensorListViewSpec',
    //'ControllerSetCollectionSpec', 'ControllerSetViewSpec'
  ];
  
  model_jasmine_specs = [
    'BeginSpec', 'DemandSpec', 'DemandProfileSpec', 'DemandSetSpec','EndSpec',
    'FundamentalDiagramSpec', 'FundamentalDiagramProfileSpec',
    'FundamentalDiagramSetSpec', 'InputSpec','OutputSpec','LinkSpec', 
    'NodeSpec', 'LinkListSpec','NodeListSpec',
    'SensorSpec', 'SensorTypeSpec', 'SensorSetSpec', 
    'SplitratioSpec', 'SplitratioProfileSpec', 'SplitratioSetSpec'
    //'ControllerSpec','DensitySpec', 'EventSpec', 
    //'ScenarioSpec', 'SignalSpec', 
  ];
  
  util_jasmine_specs = [
    'ContextMenuHandlerSpec', 'GoogleMapRouteHandlerSpec', 'UtilSpec'
  ];
  
  load_app_classes = function(after) {
    return head.js("../js/util/Beats.js",'../js/classes-load.js', function() {
      var class_paths;
      class_paths = _.map(window.beats.models_without_extensions, function(cname) {
        return "../js/models/" + cname + ".js";
      });
      class_paths = class_paths.concat(_.flatten(_.map(window.beats.utils, function(cname) {
        return "../js/util/" + cname + ".js";
      })));
      class_paths = class_paths.concat(_.flatten(_.map(window.beats.models_with_extensions, function(cname) {
        return ["../js/models/" + cname + ".js", "../js/extensions/" + cname + ".js"];
      })));
      class_paths = class_paths.concat(_.flatten(_.map(window.beats.map_views, function(cname) {
        return "../js/views/" + cname + ".js";
      })));
      class_paths = class_paths.concat(_.flatten(_.map(window.beats.collections, function(cname) {
        return "../js/collections/" + cname + ".js";
      })));
      class_paths = class_paths.concat(_.flatten(_.map(window.beats.overrides, function(cname) {
        return "../js/overrides/" + cname + ".js";
      })));
      class_paths.push(after);
      return head.js.apply(this, class_paths);
    });
  };

  load_jasmine_specs_templates = function(after){
    return head.js('lib/jasmine-1.2.0/jasmine.js',
      'lib/jasmine-1.2.0/jasmine-html.js', 
      'lib/jasmine-jquery.js',
      'lib/jasmine-1.2.0/console-runner.js',  
      'spec/SpecHelper.js', 
        function() {
          var class_paths;
          class_paths = _.map(model_jasmine_specs, function(cname) {
            return ["spec/models/" + cname + ".js"];
          });
          class_paths = class_paths.concat(_.flatten(_.map(top_level_specs, function(cname) {
            return "spec/" + cname + ".js";
          })));
          class_paths = class_paths.concat(_.flatten(_.map(view_jasmine_specs, function(cname) {
            return "spec/views/" + cname + ".js";
          })));
          class_paths = class_paths.concat(_.flatten(_.map(collections_jasmine_specs, function(cname) {
            return "spec/collections/" + cname + ".js";
          })));
          class_paths = class_paths.concat(_.flatten(_.map(util_jasmine_specs, function(cname) {
            return "spec/util/" + cname + ".js";
          })));
          class_paths.push(after);
          return head.js.apply(this, class_paths);
        });
  };
  
  window.loadApp = function(after) {
    return head.js("../js/util/Beats.js", '../js/menu-data.js', 'scenario-xml.js', function() {
      return load_app_classes(function() {
            return load_jasmine_specs_templates(after);
      });
    });
  };

  window.runWithIncludes = function(runner) {
      head.js('https://www.google.com/jsapi', 
        '../js/vendor/jquery-1.7.1.js', 
        '../js/vendor/jquery-ui-1.8.21/js/jquery-ui-1.8.21.min.js', 
        '../js/vendor/underscore.js', 
        '../js/vendor/backbone.js',
        '../js/vendor/jquery.dataTables.min.js',
        '../js/vendor/bootstrap/js/bootstrap.min.js', 
        function() {
          google.load("maps", "3",{
                  callback: "window.loadApp(runner)",
                  other_params: "libraries=geometry,drawing&sensor=false"
                });
          });
  };
  
}).call(this);
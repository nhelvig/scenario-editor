# Originating load file: main.html.
# This set of functions and collections is used to load all the javascript 
# classes and libraries into memory.
# It also instantiates the AppView class and begin the rendering process.
load_sirius_classes = (after) ->
  head.js "js/models/Sirius.js", ->
    class_paths = _.map(
      window.sirius.models_without_extensions, (cname) -> 
        "js/models/#{cname}.js"
    )
    class_paths = class_paths.concat _.flatten(
      _.map(
        window.sirius.models_util, (cname) -> 
          "js/models/util/#{cname}.js"
      )
    )
    class_paths = class_paths.concat _.flatten(
      _.map(
        window.sirius.models_with_extensions, (cname) -> 
          ["js/models/#{cname}.js","js/models/extensions/#{cname}.js"]
        )
    )
    class_paths = class_paths.concat _.flatten(
      _.map(
        window.sirius.map_view_classes, (cname) -> 
          "js/views/#{cname}.js"
        )
    )
    class_paths = class_paths.concat _.flatten(
      _.map(
        window.sirius.collection_classes, (cname) -> 
          "js/collections/#{cname}.js"
        )
    )
    class_paths = class_paths.concat _.flatten(
      _.map(
        window.sirius.util_classes, (cname) -> 
          "js/util/#{cname}.js"
        )
    )
    class_paths.push after
    head.js.apply(@, class_paths)

window.load_sirius = ->
    head.js "js/models/Sirius.js",
            'js/menu-data.js',
            'js/sirius-classes-load.js', ->
              load_sirius_classes ->
                # load the application
                window.sirius.AppView.start()

head.js 'http://www.google.com/jsapi',
        'http://maps.googleapis.com/maps/api/js?key=AIzaSyAsii_YGX6OZ70lonsZf35cZPfOpO6ShC8&sensor=false',
        '../lib/js/jquery-1.7.1.js',
        '../lib/js/jquery-ui-1.8.21/js/jquery-ui-1.8.21.min.js',
        '../lib/js/underscore.js',
        '../lib/js/backbone.js',
        '../lib/js/jquery.dataTables.min.js',
        '../lib/js/jquery.layout.min-1.2.0.js',
        '../lib/js/d3.v2.js',
        '../lib/js/bootstrap/js/bootstrap.min.js', ->
               google.load "maps", "3",
                  callback: "window.load_sirius()",
                  other_params: "libraries=geometry,drawing&sensor=false"
            
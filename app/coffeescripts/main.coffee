# Originating load file: main.html.
# This set of functions and collections is used to load all the javascript classes and libraries into memory.
# It also instantiates the AppView class and begin the rendering process.
load_sirius_classes = (after) ->
  head.js "js/Sirius.js", ->
    class_paths = _.map(window.sirius.sirius_classes_without_extensions, (cname) -> "js/#{cname}.js")
    class_paths = class_paths.concat _.flatten(_.map(window.sirius.sirius_map_view_classes, (cname) -> "js/#{cname}.js"))
    class_paths = class_paths.concat _.flatten(_.map(window.sirius.sirius_model_view_classes, (cname) -> "js/#{cname}.js"))
    class_paths = class_paths.concat _.flatten(_.map(
      window.sirius.sirius_classes_with_extensions,
      (cname) -> ["js/#{cname}.js","js/extensions/#{cname}.js"]
    ))
    class_paths.push after
    head.js.apply(@, class_paths)

window.load_sirius = ->
    head.js "js/Sirius.js",
            'js/menu-data.js',
            'js/sirius-classes-load.js', ->
              load_sirius_classes ->
                  # static instance level event aggegator that most classes use to register their
                  # own listeners on
                  new window.sirius.AppView()

head.js('https://www.google.com/jsapi',
        '../libs/js/jquery-1.7.1.js',
        '../libs/js/jquery-ui-1.8.21/js/jquery-ui-1.8.21.min.js',
        '../libs/js/underscore.js',
        '../libs/js/backbone.js',
        '../libs/js/bootstrap/js/bootstrap.min.js', ->
               google.load("maps", "3", {
                  callback: "window.load_sirius()",
                  other_params: "libraries=geometry,drawing&sensor=false"
                 });
)
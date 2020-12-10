src = []

revision_tag = vcs_tag(
  input: 'version.h.in',
  output: 'version.h',
)
pkg_dep += declare_dependency(sources: revision_tag)

resources = gnome.compile_resources(
  'resources',
  'resources/gtemplate.gresource.xml',
  source_dir: 'resources',
  c_name: '_gtemplate',
)

libsrc = [
  'mgt-utils.c',
  'mgt-settings.c',
  'mgt-window.c',
]

libgtemplate = both_libraries(
  'gtemplate', libsrc,
  install: false,
  include_directories: top_inc,
  dependencies: pkg_dep,
)

ui_files = files(
  'resources/gtk/help-overlay.ui',
  'resources/ui/mgt-window.ui',
)

gtk_builder_tool = find_program('gtk4-builder-tool', required: false)
if gtk_builder_tool.found()
  # Separate multiple libraries by ‘:’ eg.: 'LD_PRELOAD=@0@:libhandy-1.so'...
  preload_env = 'LD_PRELOAD=@0@'.format(libgtemplate.get_shared_lib().full_path())
  foreach file: ui_files
    test('Validate @0@'.format(file), gtk_builder_tool,
         env: [preload_env],
         args: ['validate', file])
  endforeach
endif

src += [
  'main.c',
  'mgt-application.c',
  revision_tag,
  resources,
]

executable(
  'my-gtemplate',
  src,
  install: true,
  gui_app: true,
  link_args: c_link_args,
  link_with: libgtemplate.get_static_lib(),
  include_directories: top_inc,
  dependencies: pkg_dep,
)

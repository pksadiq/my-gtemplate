src = []

revision_tag = vcs_tag(
  input: 'version.h.in',
  output: 'version.h',
)

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

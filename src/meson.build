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
  'mgt-log.c',
  'mgt-utils.c',
  'mgt-settings.c',
  'mgt-window.c',
]

libgtemplate_shared = shared_library(
  'gtemplate', [libsrc, 'library.c'],
  install: false,
  include_directories: top_inc,
  dependencies: pkg_dep,
)

libgtemplate_static = static_library(
  'gtemplate', libsrc,
  include_directories: top_inc,
  dependencies: pkg_dep,
)

ui_files = files(
  'resources/gtk/help-overlay.ui',
  'resources/ui/mgt-window.ui',
)

gtk_builder_tool = find_program('gtk4-builder-tool', required: false)
if gtk_builder_tool.found()
  preload_env = 'LD_PRELOAD=libadwaita-1.so:@0@'.format(libgtemplate_shared.full_path())
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
  win_subsystem: 'windows',
  link_with: libgtemplate_static,
  include_directories: top_inc,
  dependencies: pkg_dep,
)

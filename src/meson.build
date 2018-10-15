src = []

resources = gnome.compile_resources(
  'resources',
  'resources/gtemplate.gresource.xml',
  source_dir: 'resources',
  c_name: '_gtemplate'
)

libsrc = [
  'mgt-utils.c',
  'mgt-settings.c',
  revision_tag,
]

libgtemplate = static_library(
  'gtemplate', libsrc,
  install: false,
  include_directories: top_inc,
  dependencies: pkg_dep
)

src += ['main.c',
        'mgt-application.c',
        'mgt-window.c',
        libsrc,
        resources,
       ]

executable(
  'my-gtemplate',
  src,
  install: true,
  link_args: c_link_args,
  include_directories: top_inc,
  dependencies: pkg_dep
)

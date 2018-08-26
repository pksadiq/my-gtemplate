project(
  'my-gtemplate', 'c',
  version: '0.0.1',
  meson_version: '>= 0.47.0',
  license: 'GPL3+',
  default_options: [
    'c_std=gnu11',
    'warning_level=1'
  ])

pkg_name      = meson.project_name()
pkg_version   = meson.project_version()
pkg_is_debug  = get_option('buildtype').startswith('debug')

pkg_prefix    = get_option('prefix')
pkg_srcdir    = meson.source_root()
pkg_builddir  = meson.build_root()
pkg_libdir    = join_paths(pkg_prefix, get_option('libdir'))
pkg_localedir = join_paths(pkg_prefix, get_option('localedir'))
pkg_datadir   = join_paths(pkg_prefix, get_option('datadir'))
pkg_schemadir = join_paths(pkg_datadir, 'glib-2.0', 'schemas')
pkg_po_dir    = join_paths(pkg_srcdir, 'po')
top_inc       = include_directories('.')
src_inc       = include_directories('src')

gnome = import('gnome')
i18n  = import('i18n')
pkg   = import('pkgconfig')
cc    = meson.get_compiler('c')


conf = configuration_data()
conf.set('ENABLE_TRACING', get_option('tracing'))
conf.set('NDEBUG', (not pkg_is_debug))
conf.set('G_DISABLE_ASSERT', (not pkg_is_debug))
conf.set('G_DISABLE_CAST_CHECKS', (not pkg_is_debug))
conf.set_quoted('GETTEXT_PACKAGE', pkg_name)
conf.set_quoted('PACKAGE_VERSION', '@VCS_TAG@')
conf.set_quoted('PACKAGE_NAME', pkg_name)
conf.set_quoted('PACKAGE_LOCALE_DIR', pkg_localedir)

vcs_tag(
  command: ['git', 'describe'],
  input: configure_file(
    output: 'config.h.in',
    configuration: conf
  ),
  output: 'config.h'
)

configure_file(
  output : 'config.h',
  configuration : conf,
)

common_flags = [
  '-DHAVE_CONFIG_H',
  '-D_FORTIFY_SOURCE=2'
]

add_global_arguments(common_flags, language: 'c')
c_link_args = cc.get_supported_arguments(
  ['-Wall',
   '-Werror=format-security',
   '-Werror=implicit-function-declaration',
   '-fasynchronous-unwind-tables',
   '-pipe',
  ])

pkg_dep = [
  dependency('glib-2.0', version: '>= 2.44.0'),
  dependency('gtk+-4.0', version: '>= 3.92.0'),
]

subdir('src')
subdir('data')
subdir('docs')
subdir('tests')

if get_option('w32')
  subdir('build-aux/w32')
endif

if get_option('po')
  subdir('po')
endif

if get_option('bash_completion')
  subdir('completion')
endif

meson.add_install_script('build-aux/meson_post_install.py')

run_target('make-po',
           command: [
             find_program('build-aux/make_po.sh'),
             pkg_name,
             meson.current_build_dir(),
             join_paths(pkg_srcdir, 'po')
           ])

run_target('make-help-po',
           command: [
             find_program('build-aux/make_po.sh'),
             'org.sadiqpk.GTemplate',
             meson.current_build_dir(),
             join_paths(pkg_srcdir, 'docs/help'),
             'help-',
             'true'
           ])

output = '\n        ' + pkg_name + ' ' + pkg_version + '\n'
output += '        ==============================\n\n'
output += '        prefix:          ' + pkg_prefix + '\n'
output += '        compiler:        ' + cc.get_id() + ' ' + cc.version()+ '\n'
output += '        build type:      ' + get_option('buildtype') + '\n'
output += '        tracing:         ' + get_option('tracing').to_string() + '\n'
output += '        manpage:         ' + get_option('man').to_string() + '\n'
output += '        documentation:   ' + get_option('gtk_doc').to_string() + '\n'
output += '        help:            ' + get_option('help').to_string() + '\n'
output += '        translation:     ' + get_option('po').to_string() + '\n'
output += '        bash-completion: ' + get_option('bash_completion').to_string() + '\n'
output += '        Now type \'make\' to build ' + pkg_name + '\n'
message(output)

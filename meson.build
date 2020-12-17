project(
  'my-gtemplate', 'c',
  version: '0.0.1',
  meson_version: '>= 0.50.0',
  license: 'GPL3+',
  default_options: [
    'c_std=gnu11',
    'warning_level=1',
    'buildtype=debugoptimized'
  ])

pkg_name      = meson.project_name()
pkg_id        = 'org.sadiqpk.GTemplate'
pkg_version   = meson.project_version()
pkg_is_debug  = get_option('buildtype').startswith('debug')

pkg_prefix    = get_option('prefix')
pkg_srcdir    = meson.source_root()
pkg_builddir  = meson.build_root()
pkg_bindir    = join_paths(pkg_prefix, get_option('bindir'))
pkg_libdir    = join_paths(pkg_prefix, get_option('libdir'))
pkg_localedir = join_paths(pkg_prefix, get_option('localedir'))
pkg_datadir   = join_paths(pkg_prefix, get_option('datadir'))
pkg_schemadir = join_paths(pkg_datadir, 'glib-2.0', 'schemas')
pkg_po_dir    = join_paths(pkg_srcdir, 'po')
top_inc       = include_directories('.')
src_inc       = include_directories('src')

gnome = import('gnome')
i18n  = import('i18n')
cc    = meson.get_compiler('c')


conf = configuration_data()
conf.set('ENABLE_TRACING', get_option('tracing'))
conf.set('NDEBUG', (not pkg_is_debug))
conf.set('G_DISABLE_ASSERT', (not pkg_is_debug))
conf.set('G_DISABLE_CAST_CHECKS', (not pkg_is_debug))
conf.set_quoted('GETTEXT_PACKAGE', pkg_name)
conf.set_quoted('PACKAGE_NAME', pkg_name)
conf.set_quoted('PACKAGE_VERSION', pkg_version)
conf.set_quoted('PACKAGE_ID', pkg_id)
conf.set_quoted('PACKAGE_LOCALE_DIR', pkg_localedir)
if get_option('help')
  conf.set_quoted('PACKAGE_HELP_URL', 'help:' + pkg_id)
else
  conf.set_quoted('PACKAGE_HELP_URL', 'https://gitlab.com/sadiq/my-gtemplate/wiki')
endif

configure_file(
  output: 'config.h',
  configuration: conf,
)

common_flags = [
  '-DHAVE_CONFIG_H',
  '-D_FORTIFY_SOURCE=2',
]

add_global_arguments(common_flags, language: 'c')
c_link_args = cc.get_supported_arguments(
  ['-fasynchronous-unwind-tables',
   '-fno-strict-aliasing',
   '-Wall',
   '-Wcast-align',
   '-Wdate-time',
   '-Werror=format-security',
   '-Werror=implicit-function-declaration',
   '-Werror=pointer-to-int-cast',
   '-Werror=redundant-decls',
   '-Werror=return-type',
   '-Werror=vla',
   '-Werror=write-strings',
   '-Wfloat-equal',
   '-Wformat=2',
   '-Wimplicit-fallthrough',
   '-Wlogical-op',
   '-Wmissing-format-attribute',
   '-Wmissing-include-dirs',
   '-Wmissing-prototypes',
   '-Wnested-externs',
   '-Wold-style-declaration',
   '-Wold-style-definition',
   '-Wpointer-arith',
   '-Wshadow',
   '-Wswitch-default',
   '-Wswitch-enum',
   '-Wtrigraphs',
   '-Wunused',
   '-pipe',
  ])

if cc.get_id() == 'msvc'
  warning('Your compiler doesn\'t support C99/C11 features.' +
          ' Please use MinGW or native GNU/Linux')
endif

pkg_dep = [
  dependency('glib-2.0', version: '>= 2.44.0'),
  dependency('gtk4', version: '>= 3.94.0'),
]

subdir('src')
subdir('data')
subdir('docs')

if get_option('tests')
  subdir('tests')
endif

if host_machine.system() == 'windows'
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
             join_paths(pkg_srcdir, 'po'),
           ])

run_target('make-help-po',
           command: [
             find_program('build-aux/make_po.sh'),
             pkg_id,
             meson.current_build_dir(),
             join_paths(pkg_srcdir, 'docs/help'),
             'help-',
             'true',
           ])

system = host_machine.system()
if system == 'linux'
  system = 'GNU/Linux'
endif

output = '\n        ' + pkg_name + ' ' + pkg_version + '\n'
output += '        ==============================\n\n'
output += '        prefix:          ' + pkg_prefix + '\n'
output += '        compiler:        ' + cc.get_id() + ' ' + cc.version()+ '\n'
output += '        compiler args:   ' + ' '.join(c_link_args) + '\n'
output += '        build type:      ' + get_option('buildtype') + '\n'
output += '        host system:     ' + system + '\n'
output += '        tracing:         ' + get_option('tracing').to_string() + '\n'
output += '        tests:           ' + get_option('tests').to_string() + '\n'
output += '        manpage:         ' + get_option('man').to_string() + '\n'
output += '        documentation:   ' + get_option('gtk_doc').to_string() + '\n'
output += '        translations:    ' + get_option('po').to_string() + '\n'
output += '        help:            ' + get_option('help').to_string() + '\n'
output += '        translation:     ' + get_option('po').to_string() + '\n'
output += '        bash-completion: ' + get_option('bash_completion').to_string() + '\n'
message(output)

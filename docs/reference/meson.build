docs_conf = configuration_data()
docs_conf.set('PACKAGE_VERSION', pkg_version)

private_headers = [
  'config.h',
]

docpath = join_paths(get_option('datadir'), 'gtk-doc', 'html')

# External dependencies to fix cross referencing.
glib_prefix = dependency('glib-2.0').get_variable(pkgconfig: 'prefix')
glib_docpath = join_paths(glib_prefix, 'share', 'gtk-doc', 'html')
gtk_prefix = dependency('gtk4').get_variable(pkgconfig: 'prefix')
gtk_docpath = join_paths(gtk_prefix, 'share', 'gtk-doc', 'html')

docs_version = configure_file(
  input: 'version.xml.in',
  output: 'version.xml',
  configuration: docs_conf,
)

gnome.gtkdoc(
  'my-gtemplate',
  main_xml: 'my-gtemplate-docs.xml',
  src_dir: [
    join_paths(pkg_srcdir, 'src'),
    join_paths(pkg_builddir, 'src'),
  ],
  ignore_headers: private_headers,

  fixxref_args: [
    '--html-dir=@0@'.format(docpath),
    '--extra-dir=@0@'.format(glib_docpath),
    '--extra-dir=@0@'.format(gtk_docpath),
  ],

  install: true,
)

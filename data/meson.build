desktop_file = i18n.merge_file(
  input: pkg_id + '.desktop.in',
  output: pkg_id + '.desktop',
  type: 'desktop',
  po_dir: pkg_po_dir,
  install: true,
  install_dir: join_paths(pkg_datadir, 'applications'),
)

install_data(
  pkg_id + '.gschema.xml',
  install_dir: pkg_schemadir,
)

if get_option('tests')
  compiled = gnome.compile_schemas()
endif

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils,
       args: [desktop_file])
endif

compile_schemas = find_program('glib-compile-schemas', required: false)
if compile_schemas.found()
  test('Validate schema file', compile_schemas,
       args: ['--strict', '--dry-run', meson.current_source_dir()])
endif

subdir('appdata')
subdir('icons')

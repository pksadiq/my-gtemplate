appstream_file = i18n.merge_file(
  input: pkg_id + '.appdata.xml.in',
  output: pkg_id + '.appdata.xml',
  po_dir: pkg_po_dir,
  install: true,
  install_dir: join_paths(pkg_datadir, 'metainfo')
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util,
       args: ['validate', appstream_file])
endif

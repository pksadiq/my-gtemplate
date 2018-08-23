appstream_file = i18n.merge_file(
  input: 'org.sadiqpk.GTemplate.appdata.xml.in',
  output: 'org.sadiqpk.GTemplate.appdata.xml',
  po_dir: pkg_po_dir,
  install: true,
  install_dir: join_paths(pkg_datadir, 'metainfo')
)

appstream_util = find_program('appstream-util', required: false)
if appstream_util.found()
  test('Validate appstream file', appstream_util,
       args: ['validate', appstream_file])
endif

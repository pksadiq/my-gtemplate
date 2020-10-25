appstream_args = []

appstream_file = i18n.merge_file(
  input: pkg_id + '.metainfo.xml.in',
  output: pkg_id + '.metainfo.xml',
  po_dir: pkg_po_dir,
  install: true,
  install_dir: join_paths(pkg_datadir, 'metainfo'),
)

appstream_util = find_program('appstream-util', required: false)

if not get_option('network_tests')
  appstream_args += '--nonet'
endif
appstream_args += ['validate-relax', appstream_file]

if appstream_util.found()
  test('Validate appstream file', appstream_util,
       args: appstream_args)
endif

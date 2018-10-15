xsltproc = find_program('xsltproc', required: true)

xsltproc_args = [
  '--nonet',
  '--stringparam', 'man.output.quietly', '1',
  '--stringparam', 'funcsynopsis.style', 'ansi',
  '--stringparam', 'man.th.extra1.suppress', '1',
  '--stringparam', 'man.authors.section.enabled', '1',
  '--stringparam', 'man.copyright.section.enabled', '0',
]

man_files = [
  [ 'my-gtemplate', '1', ],
]

foreach man: man_files
  man_name = man.get(0)
  man_section = man.get(1, '1')
  custom_target(
    '@0@.@1@'.format(man_name, man_section),
    input: '@0@.xml'.format(man_name),
    output: '@0@.@1@'.format(man_name, man_section),
    command: [
      xsltproc,
      xsltproc_args,
      '-o', '@OUTPUT@',
      'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl',
      '@INPUT@',
    ],
    install: true,
    install_dir: join_paths(get_option('mandir'), 'man@0@'.format(man_section)),
  )
endforeach

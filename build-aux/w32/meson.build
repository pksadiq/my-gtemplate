conf = configuration_data()
conf.set('SRC_DIR', pkg_srcdir)
conf.set('VCS_TAG', '@VCS_TAG@')

sh = vcs_tag(
  command: ['git', 'describe'],
    input: configure_file(
      input: 'defaults.sh.in',
      output: 'defaults.sh.in',
      configuration: conf
    ),
    output: 'defaults.sh'
  )

wxi = vcs_tag(
  command: ['git', 'describe'],
  input: configure_file(
    input: 'defines.wxi.in',
    output: 'defines.wxi.in',
    configuration: conf
  ),
  output: 'defines.wxi'
)

run_target('dist-msi',
           depends: [sh, wxi],
           command: [
             find_program('make-w32.sh'),
             pkg_builddir
           ])


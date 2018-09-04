conf = configuration_data()
conf.set('SRC_DIR', pkg_srcdir)
conf.set('VCS_TAG', '@VCS_TAG@')
conf.set('ARCH', host_machine.cpu())

sh = vcs_tag(
    input: configure_file(
      input: 'defaults.sh.in',
      output: 'defaults.sh.in',
      configuration: conf
    ),
    output: 'defaults.sh'
  )

wxi = vcs_tag(
  input: configure_file(
    input: 'defines.wxi.in',
    output: 'defines.wxi.in',
    configuration: conf
  ),
  output: 'defines.wxi'
)

if get_option('optimize')
  optimize='yes'
else
  optimize='no'
endif

run_target('dist-msi',
           depends: [sh, wxi],
           command: [
             find_program('make-w32-msi.sh'),
             optimize
           ])


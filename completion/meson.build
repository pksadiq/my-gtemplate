bash_comp_dep = dependency('bash-completion', version: '>=2.10', required: false)
bash_comp_dir = ''

if bash_comp_dep.found()
  bash_comp_dir = bash_comp_dep.get_pkgconfig_variable('completionsdir',
                                                       define_variable: ['datadir', pkg_datadir])
endif

if bash_comp_dir == ''
  bash_comp_dir = join_paths(pkg_datadir, 'bash-completion', 'completions')
endif

install_data(
  meson.project_name(),
  install_dir: bash_comp_dir
)

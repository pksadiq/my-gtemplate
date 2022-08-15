bash_comp_dep = dependency('bash-completion', version: '>=2.11', required: true)
bash_comp_dir = bash_comp_dep.get_variable(pkgconfig :'completionsdir')

install_data(
  meson.project_name(),
  install_dir: bash_comp_dir
)

tests_inc = [
  top_inc,
  src_inc,
]

env = environment()
env.set('G_TEST_SRCDIR', meson.current_source_dir())
env.set('G_TEST_BUILDDIR', meson.current_build_dir())
env.set('GSETTINGS_SCHEMA_DIR', join_paths(pkg_builddir, 'data'))
env.set('GSETTINGS_BACKEND', 'memory')
env.set('G_DEBUG', 'gc-friendly')
env.set('MALLOC_CHECK_', '2')

test_items = [
  'log',
  'settings',
  'utils',
]

foreach item: test_items
  t = executable(
    item,
    item + '.c',
    include_directories: tests_inc,
    link_with: libgtemplate_static,
    dependencies: pkg_dep,
  )
  test(item, t, env: env)
endforeach

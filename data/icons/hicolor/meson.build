icon_sizes = [
  '16x16',
  '22x22',
  '32x32',
  '48x48',
  '256x256',
  '512x512',
  'scalable',
  'symbolic',
]

foreach icon_size: icon_sizes
  install_subdir(
    icon_size,
    install_dir: join_paths(pkg_datadir, 'icons', 'hicolor'),
  )
endforeach

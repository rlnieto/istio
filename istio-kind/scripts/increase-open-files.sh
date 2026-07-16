# Incrementa temporalmente el numero de ficheros que pueden estar
# abiertos simultáneamente (la configuración desaparece al reiniciar
# el host)
# Hacemos esto porque al usar kind a veces no son suficientes los que
# están configurados en el host
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl fs.inotify.max_user_instances=512
sudo sysctl fs.file-max=100000
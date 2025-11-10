# handlers simples
command_not_found_handler() {
  print -u2 "comando não encontrado: $1"
  thefuck
  return thefuck
}

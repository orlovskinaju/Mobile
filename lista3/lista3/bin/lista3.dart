import 'package:lista3/lista3.dart' as lista3;

void main(List<String> arguments) {
  lista3.Baralho baralho = lista3.Baralho();
  baralho.embaralhar();

  print("Distribuindo 5 cartas:");
  for (int i = 0; i < 5; i++) {
    print(baralho.comprar());
  }

  print("\nCartas restantes no baralho: ${baralho.cartasRestantes()}");
}

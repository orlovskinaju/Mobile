void exe1(int a, int b, int c){
  int soma = a+b;
  String mensagem = soma<c ? 'A soma de a e b é menor que c' : 'A soma de a e b é maior ou igual a c';
  print(mensagem);  
}

void exe2(int a) =>
  print(a % 2 == 0 ? 'O número é par' : 'O número é ímpar');

void exe3(int a, int b){
  int c;
  if (a==b){
    c = a+b;
  }else {
    c = a*b;
  }
  print(c);
}
void exe4(int a, int b, int c){
  int maior;
  if (a==b || b==c){
    print ('números são iguais');
  }else{
    if (a>b && a>c){
      maior = a;
    }else if (b>a && b>c){
      maior = b;
    }else{
      maior = c;
    }
    print('O maior número é $maior');
  }
}
void exe5() {
  int soma = 0;
  for (int i = 1; i <= 500; i++) {
    soma += (i % 2 != 0 && i % 3 == 0) ? i : 0;
  }
  print('Soma dos números ímpares múltiplos de 3 entre 1 e 500: $soma');
}

void exe6() {
  for (int i = 101; i < 200; i += 2) {
    print(i);
  }
}

void exe7(int n) =>
  (n < 1 || n > 10)
    ? print('Valor inválido. Digite um número de 1 a 10.')
    : {
        for (int i = 0; i <= 10; i++) print('$i x $n = ${i * n}')
      };


void exe8(int a) {
  int fatorial = 1;
  String sequencia = '';
  for (int i = a; i > 0; i--) {
    fatorial *= i;
    sequencia += (i != 1) ? '$i x ' : '$i';
  }
  print('$a!: $sequencia = $fatorial');
}